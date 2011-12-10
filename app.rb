require "rubygems"
require "bundler"
Bundler.require(:default)


set :root, File.dirname(__FILE__)
set :public_folder,  './public'

set :cache_enabled, true  # turn it on

set :environment, :production

approot = File.dirname(__FILE__)
set :root, approot

$: << File.join(approot, "vendor")
require 'gappsprovisioning/provisioningapi'

include GAppsProvisioning

helpers do
  
  def gmail(msg_info = {})
    @to = msg_info[:to] || 'alec@thesprouts.org' 
    Pony.mail(:to => @to, :subject => msg_info[:subject], :body => msg_info[:body], :via => :smtp, 
              :via_options => {
                :address              => 'smtp.gmail.com',
                :port                 => '587',
                :enable_starttls_auto => true,
                :user_name            => 'some.sprouts',
                :password             => 'spr0utward',
                :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
                :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
              })
  end
end

get '/' do
  File.read(File.dirname(__FILE__) + '/index.html')
end

post '/mailinglist/signup/:list' do
  adminuser = "alec@thesprouts.org"
  password  = "epii10"
  email = params[:email]
  mailing_list = params[:list]
  myapps = ProvisioningApi.new(adminuser,password)
  myapps.add_member_to_group(email, mailing_list)
  gmail(:to => 'alec@thesprouts.org', :subject => "HEY HEY GUESS WHAT, #{params[:email]} JUST SIGNED UP FOR #{params[:list]}!", :body => "Totally not joking--")
end
