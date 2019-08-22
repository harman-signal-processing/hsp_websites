require "rails_helper"

feature "User browses training courses" do

  before :all do
    @brand = FactoryBot.create :brand, has_training: true
    @website = FactoryBot.create :website, brand: @brand
    @training_course = FactoryBot.create :training_course, brand: @brand

    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  after :all do
    DatabaseCleaner.clean_with :deletion
  end

  context "starting with homepage" do
    it "should have a link to training page" do
      visit root_path

      expect(page).to have_link("Training")
    end
  end

  context "training index" do
    it "should have links to training modules if any" do
      product = FactoryBot.create :product, brand: @brand
      training_module = FactoryBot.create :training_module, brand: @brand
      product.training_modules << training_module

      visit training_path

      expect(page).to have_link(training_module.name)
    end

    it "should have links to training coursess if any" do
      visit training_path

      expect(page).to have_content(@training_course.name)
    end

    it "should show the training schedule" do
      training_class = FactoryBot.create :training_class, training_course: @training_course

      visit training_path

      expect(page).to have_content(training_class.name)
      expect(page).to have_content(I18n.l(training_class.start_at, format: :log))
      expect(page).to have_content(I18n.l(training_class.end_at, format: :log))
      expect(page).to have_link("Register")
    end

    it "should have registration form" do
      training_class = FactoryBot.create :training_class, training_course: @training_course

      visit training_path

      expect(page).to have_link("Register", href: new_training_course_training_class_training_class_registration_path(@training_course, training_class, locale: I18n.default_locale))
    end

    it "should link to Harman professional university" do
      visit training_path

      expect(page).to have_content("HARMAN Professional University")
      expect(page).to have_link("Get started", href: "https://traininglogin.harmanpro.com/")
    end

    it "should link to brand-specific online training portal (if any)" do
      FactoryBot.create(:setting, brand: @brand, name: "live_online_training_url", string_value: "http://foo.com")

      visit training_path

      expect(page).to have_content("Live/Online Training from #{ @brand.name }")
      expect(page).to have_link("Get started", href: "http://foo.com")
    end

    it "should show the short description of the course" do
      visit training_path

      expect(page).to have_content(@training_course.short_description)
    end

  end

  context "external course" do
    it "should link to external course info" do
      ext_training_course = FactoryBot.create :training_course, brand: @brand, more_info_url: "https://foo.com"

      visit training_path

      expect(page).to have_link(I18n.t('more_info'), href: ext_training_course.more_info_url)
    end
  end

  context "internal course" do
    it "should link to course page" do
      visit training_path

      expect(page).to have_link(I18n.t('more_info'), href: training_course_path(@training_course, locale: I18n.default_locale))
    end

    context "course page" do
      before :each do
        @training_class = FactoryBot.create :training_class, training_course: @training_course

        visit training_course_path(@training_course, locale: I18n.default_locale)
      end

      it "should show full details" do
        expect(page).to have_content(@training_course.name)
        expect(page).to have_content(@training_course.description)
      end

      it "should show schedule for the course" do
        expect(page).to have_content(@training_class.name)
        expect(page).to have_content(I18n.l(@training_class.start_at, format: :log))
        expect(page).to have_content(I18n.l(@training_class.end_at, format: :log))
        expect(page).to have_link("Register")
      end

      it "should have registration form for upcoming classes" do
        expect(page).to have_link("Register", href: new_training_course_training_class_training_class_registration_path(@training_course, @training_class, locale: I18n.default_locale))
      end
    end

    context "registration form" do
      before :each do
        @instructor = FactoryBot.create :user
        @training_class = FactoryBot.create :training_class, training_course: @training_course, instructor: @instructor

        visit training_course_path(@training_course, locale: I18n.default_locale)
        click_on "Register"
      end

      it "should collect user info" do
        expect(page).to have_field("Name")
        expect(page).to have_field("Email")
        expect(page).to have_field("Comments")
        expect(page).to have_button("Submit")
      end

      it "should save user information and redirect to course page" do
        reg_before = TrainingClassRegistration.count
        fill_in "Name", with: "Harry Von Harrison"
        fill_in "Email", with: "harry@vonharrison.com"
        click_on "Submit"

        expect(TrainingClassRegistration.count).to eq(reg_before + 1)
        expect(page).to have_current_path(training_course_path(@training_course, locale: I18n.default_locale))
      end

      it "should send email to specified contact for the course" do
        fill_in "Name", with: "Harry Von Harrison"
        fill_in "Email", with: "harry@vonharrison.com"
        click_on "Submit"

        last_email = get_last_email
        expect(last_email.to).to include(@training_course.send_registrations_to)
      end

      it "should send email to the instructor" do
        fill_in "Name", with: "Harry Von Harrison"
        fill_in "Email", with: "harry@vonharrison.com"
        click_on "Submit"

        last_email = get_last_email
        expect(last_email.to).to include(@training_class.instructor.email)
      end

      it "should include registration info in the email" do
        fill_in "Name", with: "Harry Von Harrison"
        fill_in "Email", with: "harry@vonharrison.com"
        click_on "Submit"

        last_email = get_last_email
        expect(last_email.subject).to eq(@training_class.name)
        expect(last_email.body).to include("Harry Von Harrison")
        expect(last_email.body).to match("harry@vonharrison.com")
        expect(last_email.body).to match(@training_class.location)
      end
    end
  end

  def get_last_email
    ActionMailer::Base.deliveries.last
  end
end
