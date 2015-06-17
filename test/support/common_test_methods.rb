module CommonTestMethods
  def digitech_brand
    @digitech_brand ||= FactoryGirl.create(:digitech_brand)
  end

  def digitech_site
    @digitech_site ||= FactoryGirl.create(:website_with_products, folder: "digitech", brand: digitech_brand)
  end

  def lexicon_brand
    @lexicon_brand ||= FactoryGirl.create(:lexicon_brand)
  end

  def lexicon_site
    @lexicon_site ||= FactoryGirl.create(:website_with_products, folder: "lexicon", brand: lexicon_brand)
  end

  def bss_brand
    @bss_brand ||= FactoryGirl.create(:bss_brand)
  end

  def bss_site
    @bss_site ||= FactoryGirl.create(:website_with_products, folder: "bss", brand: bss_brand)
  end

  def dbx_brand
    @dbx_brand ||= FactoryGirl.create(:dbx_brand)
  end

  def dbx_site
    @dbx_site ||= FactoryGirl.create(:website_with_products, folder: "dbx", brand: dbx_brand)
  end

  def setup_toolkit_brands
    @digitech = digitech_brand
    @digitech_site = digitech_site
    @lexicon = lexicon_brand
    @lexicon_site = lexicon_site
    @bss = bss_brand
    # @bss_site = bss_site
    @dbx = dbx_brand
    @dbx_site = dbx_site
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def admin_login_with(user, password, website)
    user.confirm
    visit new_user_session_url(host: website.url, locale: I18n.default_locale)
    fill_in('user[email]', with: user.email)
    fill_in('user[password]', with: password)
    click_button 'Sign in'
  end

  def setup_and_login_queue_user
    @password = "pass123"
    @user = FactoryGirl.create(:user,
                               marketing_staff: true,
                               name: "Johnny Danger",
                               password: @password,
                               password_confirmation: @password)
    @user.confirm
    visit new_marketing_queue_user_session_url(host: @host)
    fill_in :marketing_queue_user_email, with: @user.email
    fill_in :marketing_queue_user_password, with: @password
    click_on "Sign in"
  end

  def setup_and_login_queue_admin
    @password = "pass123"
    @user = FactoryGirl.create(:user,
                               marketing_staff: true,
                               name: "Jason Kunz",
                               queue_admin: true,
                               password: @password,
                               password_confirmation: @password)
    @user.confirm
    visit new_marketing_queue_user_session_url(host: @host)
    fill_in :marketing_queue_user_email, with: @user.email
    fill_in :marketing_queue_user_password, with: @password
    click_on "Sign in"
  end

  def setup_and_login_market_manager
    @password = "pass123"
    @user = FactoryGirl.create(:user,
                               marketing_staff: true,
                               name: "G. Scott",
                               market_manager: true,
                               password: @password,
                               password_confirmation: @password)
    @user.confirm
    visit new_marketing_queue_user_session_url(host: @host)
    fill_in :marketing_queue_user_email, with: @user.email
    fill_in :marketing_queue_user_password, with: @password
    click_on "Sign in"
  end
end
