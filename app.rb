  # import libs
# import routes

require 'sinatra'
require 'sinatra/asset_pipeline'
require 'sinatra/partial'

MAIL_ATTRIBUTES = [:name, :mail , :budget]

def invalid_attributes
  attributes = []
  MAIL_ATTRIBUTES.each do |attr|
    attributes << attr if params[:message][attr].nil? || params[:message][attr].strip.empty?
  end
  attributes << :mail unless params[:message][:mail] && params[:message][:mail].match(/.+@.+\..+/)
  attributes
end

def is_valid_mail?
  invalid_attributes.empty? && not_spam?
end

def not_spam?
  antispam = params[:message][:antispam]
  spam = params[:message][:spam]
  antispam == '' && spam == ''
end

class App < Sinatra::Base
  #set :assets_prefix, %w(assets assets/sass)
  set :assets_precompile, %w(*.js styles.css *.png *.jpg *.svg *.eot *.ttf *.woff)
  set :assets_css_compressor, :sass
  set :assets_js_compressor, :uglifier
  register Sinatra::AssetPipeline

  # Partials
  register Sinatra::Partial
  set :partial_template_engine, :slim

  get '/' do
    slim :index
  end

  post '/contact' do
    return redirect("/?errors=#{invalid_attributes.map(&:to_s).join(",")}") unless is_valid_mail?
    name = params[:message][:name]
    mail = params[:message][:mail]
    budget = params[:message][:budget]
    body = params[:message][:body]
    Pony.mail(
      :to => 'contato@codeland.com.br',
      :from => mail,
      :reply_to => mail,
      :subject => 'Desenvolvimento de Sistema Web',
      :body => "Nome: #{name}\n" + "E-mail: #{mail}\n" + "Orçamento: #{budget}\n" + body,
      :via => :smtp,
      :via_options => {
        :address => 'smtp.sendgrid.net',
        :port => '587',
        :domain => 'heroku.com',
        :user_name => ENV['SENDGRID_USERNAME'],
        :password => ENV['SENDGRID_PASSWORD'],
        :authentication => :plain,
        :enable_starttls_auto => true
      }
    )
    redirect "/?success=success"
  end
end
