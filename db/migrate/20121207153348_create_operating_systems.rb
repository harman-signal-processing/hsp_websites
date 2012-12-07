class CreateOperatingSystems < ActiveRecord::Migration
  def up
    create_table :operating_systems do |t|
      t.string :name
      t.string :version
      t.string :arch

      t.timestamps
    end
    OperatingSystem.create([
    	{name: "Windows", version: "95",    arch: "32-bit"},
    	{name: "Windows", version: "98",    arch: "32-bit"},
    	{name: "Windows", version: "2000",  arch: "32-bit"},
    	{name: "Windows", version: "XP",    arch: "32-bit"},
    	{name: "Windows", version: "XP",    arch: "64-bit"},
    	{name: "Windows", version: "NT",    arch: "32-bit"},
    	{name: "Windows", version: "Vista", arch: "32-bit"},
    	{name: "Windows", version: "Vista", arch: "64-bit"},
    	{name: "Windows", version: "7",     arch: "32-bit"},
    	{name: "Windows", version: "7",     arch: "64-bit"},
    	{name: "Windows", version: "8",     arch: "32-bit"},
    	{name: "Windows", version: "8",     arch: "64-bit"},

    	{name: "Mac OS X", version: "10.4 Tiger",         arch: "PPC"},
    	{name: "Mac OS X", version: "10.5 Leopard",       arch: "PPC"},
    	{name: "Mac OS X", version: "10.5 Leopard",       arch: "32-bit Intel"},
    	{name: "Mac OS X", version: "10.5 Leopard",       arch: "64-bit Intel"},
    	{name: "Mac OS X", version: "10.6 Snow Leopard",  arch: "32-bit Intel"},
    	{name: "Mac OS X", version: "10.6 Snow Leopard",  arch: "64-bit Intel"},
    	{name: "Mac OS X", version: "10.7 Lion",          arch: "32-bit Intel"},
    	{name: "Mac OS X", version: "10.7 Lion",          arch: "64-bit Intel"},
    	{name: "Mac OS X", version: "10.8 Mountain Lion", arch: "32-bit Intel"},
    	{name: "Mac OS X", version: "10.8 Mountain Lion", arch: "64-bit Intel"},

    	{name: "iOS", version: "3.x"},
    	{name: "iOS", version: "4.x"},
    	{name: "iOS", version: "5.x"},
    	{name: "iOS", version: "6.x"},

    	{name: "Linux", arch: "32-bit"},
    	{name: "Linux", arch: "64-bit"}
    ])
  end

  def down
  	drop_table :operating_systems
  end
end
