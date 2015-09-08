# LR5

## Chapter 6

#### "Presenting Models with Forms"

At the terminal, run the following command to create a new application:

	rails new guestbook

Enter the following to create scaffolding for the app with a basic data structure:

	rails generate scaffold Person name:string secret:string country:string email:string description:text can_send_email:boolean graduation_year:integer body_temperature:float price:decimal birthday:date favorite_time:time

Now run `rake db:migrate` to implement the migration created with the scaffold generator. Note that just like the last exercise, the *people_controller* has been generated complete with strong parameters - defined in a private method called *person_params*. This time, however, the person model can accept all of the attributes we specified when running the *rails generate scaffold* command.

Open *localhost:3000/people* in the browser to start the new application. Click the "New Person" link to view the form that Rails has generated to create a new "person" object. The code for this form, in *app/views/people/_form.html.erb*, uses the Rails method `form_for`, which automatically binds the input values to the Person model.

#### "Creating Text Fields and Text Areas"

In a text editor, open *app/views/people/_form.html.erb* and localte the following block of code:

	<div class="field">
    		<%= f.label :secret %><br>
    		<%= f.text_field :secret %>
	</div>

Change the code so that the line the "secret" attribute uses the *password_field* method:

	<%= f.password_field :secret %>

This will display asterisks (or dots, depending on browser defaults or any style modifications) when the user enters their "secret" criteria.
