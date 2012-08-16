class SoftwareActivation < ActiveRecord::Base
  belongs_to :software
  validates :software, presence: true
  validates :challenge, presence: true, uniqueness: {scope: :software_id}
  after_initialize :generate_key
  alias_attribute :key, :activation_key
  
  # Generate the activation key
  def generate_key
    begin
      multipliers = eval(self.software.multipliers)
      key = []
      self.challenge.split("-").each_with_index do |word,i|
        word = word.to_i(16) # convert hex to dec
        word *= (word[0].even?) ? multipliers[i][:even] : multipliers[i][:odd]      
        key << word.to_s(16).reverse[0,8].reverse # convert dec to hex, keep only 8 rightmost hex characters
      end
      self.activation_key = key.join("-").upcase
    rescue
      self.activation_key = "error!"
    end
  end
  
  # Determine the related software package name
  def software_name
    begin
      self.software.name
    rescue
      "not found"
    end
  end
  
end
