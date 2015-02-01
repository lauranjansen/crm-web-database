require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")

class Contact
	include DataMapper::Resource

	property :id, Serial
	property :first_name, String
	property :last_name, String
	property :email, String
	property :note, String
end

DataMapper.finalize
DataMapper.auto_upgrade!

# Contact.create(first_name: "Johnny", last_name: "Bravo", email: "johnny@bravo.com", note: "Rockstar")
# Contact.create(first_name: "Day Z.", last_name: "Kutter", email: "daisy@cutter.com", note: "Knife guy")
# Contact.create(first_name: "Derek", last_name: "Zoolander", email: "derek@cfkwcrg.com", note: "Supermodel")
# Contact.create(first_name: "Faith", last_name: "Connors", email: "mirrors@edge.com", note: "Runner")
# Contact.create(first_name: "Edna", last_name: "Mode", email: "edna@mode.com", note: "Designer")
# Contact.create(first_name: "Lauran", last_name: "Jansen", email: "lauran.jansen@gmail.com", note: "Coder")

$crm_name = "My CRM"

get '/'  do
	@title = "Home - #{$crm_name}"
	erb :index
end

get '/contacts' do
	@title = "Contacts - #{$crm_name}"
	@contacts = Contact.all
  erb :contacts
end

get '/contacts/new_contact' do
	@title = "New Contact - #{$crm_name}"
	erb :new_contact
end

post '/contacts' do
	p params
	contact = Contact.create(
		:first_name => params[:first_name],
		:last_name => params[:last_name],
		:email => params[:email],
		:note => params[:note]
	)
	redirect '/contacts'
end

get '/contacts/:id' do
	@contact = Contact.get(params[:id].to_i)
	if @contact
		@title = "#{@contact.first_name} #{@contact.last_name} - #{$crm_name}"
    erb :contact
  else
    raise Sinatra::NotFound
  end
end

get "/contacts/:id/edit" do
	@contact = Contact.get(params[:id].to_i)
	if @contact
		@title = "Edit Contact - #{$crm_name}"
		erb :edit_contact
	else
		raise Sinatra::NotFound
	end
end

put "/contacts/:id" do
	@contact = Contact.get(params[:id].to_i)
	puts params
	if @contact
		@contact.update(:first_name => params[:first_name])
		@contact.update(:last_name => params[:last_name])
		@contact.update(:email => params[:email])
		@contact.update(:note => params[:note])

		redirect to("/contacts")
	else
		raise Sinatra::NotFound
	end
end

delete "/contacts/:id" do
	@contact = Contact.get(params[:id].to_i)
	if @contact
		@contact.destroy
		redirect to("/contacts")
	else
		raise Sinatra::NotFound
	end
end