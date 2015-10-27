#LR5
##Chapter 8
###"Improving Forms"

This chapter builds on the "Guestbook" application by adding support for file uploads. In addition, form builders will be added to aid in the creation of custom forms.

To begin, open last app from Chapter 7 (guestbook06) in the text editor.

<sub>Alternatively, a new app can be created (i.e. "guestbook07") that is identical to _ch07/guestbook06_.</sub>

####"Adding a Picture by Uploading a File"
#####"File Upload Forms"

In the text editor, open the **people** form in app/views/people/_form.html.erb and add the following block of code:

		<div class="field">
			<%= f.label :photo %><br>
			<%= f.file_field :photo %>
		</div>

Since the form is now a "multipart" form, accepting attachment files along with post data, the form tag (at line 1 of the file) needs to reflect these changes. Modify the **form_for** method to read like this:

		<%= form_for(@person, :html => { :multipart => true }) do |f| %>

Remember to save the updated form before proceeding.

#####"Model and Migration Changes"
**A migration for an extension**

In the terminal, ensure that the prompt is at the current app (i.e. "guestbook") directory and run the following command:

		rails generate migration add_photo_extension_to_person

Locate the migration that was just created in the _db/migrate_ directory. Add the following line of code to the _change_ method:

		def change
			add_column :people, :extension, :string
		end

Run `rake db:migrate` to add the new column to the **:people** table.

**Strong parameters, again**

The migration has added the extension as a column in the database, however the information is still coming to the application as **:photo**. This means that **:photo** needs to be "whitelisted" in the private **person_params** method (at the end of *app/controllers/people_controller.rb*. The updated **person_params** method should look like this:

		# Never trust parameters from the scary internet, only allow the white list through.
		def person_params
			params.require(:person).permit(:name, :secret, :country,
				:email, :description, :can_send_email, 
				:graduation_year, :body_temperature, :price,
				:birthday, :favorite_time, :photo)
		end

**Extending a model beyond the database**

To begin building the process by which photo files will actually be stored, open *app/models/person.rb* in the text editor. Create some whitespace before the closing (last) **end** statement and add the following method that will ensure the form data will be validated *before* attempting to store the photo:

		# callback method to store photo after validation
		after_save :store_photo

This callback references the **store_photo** method, which may be entered next. To ensure that this method can only be called from *within* this model class, use the **private** keyword just before defining the method like this..

		private
  
		# called after saving, to write the uploaded image to the filesystem
		def store_photo
			if @file_data
				# make the photo_store directory if it doesn't exist already
				FileUtils.mkdir_p PHOTO_STORE
				# write out the image data to the file
				File.open(photo_filename, 'wb') do |f|
					f.write(@file_data.read)
				end
				# avoid repeat-saving
				@file_data = nil
			end
		end

Next, add the method that will actually add the input from the form's file_field and write that data to the **person** model's **:photo** attribute (i.e. person.photo). 
Add the following method just after the **:store_photo** callback method above, paying attention to the special syntax of the _assignment method_:

		# when photo data is assigned via the upload, store the file data
		# for later and assign the file extension, e.g. ".jpg"
		def photo=(file_data)
			unless file_data.blank?
				# store the uploaded data into a private instance variable
				@file_data = file_data
				# figure out the last part of the file name and use this as
				# the file extension. e.g. from "me.jpg" will return "jpg"
				self.extension = file_data.original_filename.split('.').last.downcase
			end
		end

