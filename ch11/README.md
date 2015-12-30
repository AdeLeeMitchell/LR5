#LR5

##Chapter 11
###"Debugging"
This chapter explores the many debugging tools that Rails provides and builds on the _student03_ application from chapter 9. Copy and rename this application as _ch11/students05_. Alternatively, a new Rails app can be created named _students05_.

####Creating Your Own Debugging Messages
In the text editor, open _app/views/students/show.html.erb_ and locate the commented lines towards the bottom of the markup. Un-comment the `<%= @student %>` line and refresh the browser to view the raw output. It will look something like "**#<Student:0x007f6e14b19318>**".

Next, try un-commenting the next block of markup in the _show_ view: `<%= debug(@student) %>`. Now when the view is refreshed, we can see a very detailed collection of attributes for the **student** object.


<sup>See text for explanation of how to generate YAML-formatted output using the "debug" method</sup>

####Raising Exceptions
A brute-force way to show a YAML dump of attributes is to deliberately **raise** an exception from the controller. In *app/controllers/award_controller.rb*, locate the `show` method and add a raise method like this:

		def show
			raise @award.to_yaml
		end

Now, navigating to the show page for an award (*localhost:3000/students/1/awards/1* for example) displays a **"RuntimeError"**, along with detailed information of the award object (albeit in an unattractive format). Keep in mind, of course, that debugging methods such as these should **never** be used in a production environment.

<sup>See text for explanation of how to use the "raise" method in the controller to deliberately raise an exception for the purposes of inspecting an element.</sup>

####Logging
Rails provides a generous amount of information in the *log* files. One may instantiate the **logger** object from any model, controller, or view. In the **student** controller (*app/controllers/students_controller.rb*), call the `info` method from within the student's `create` method as follows:

		respond_to do |format|
		if @student.save
			format.html { redirect_to @student, notice: 'Student was successfully created.' }
			format.json { render :show, status: :created, location: @student }

			# Send a message to the log file
			logger.info '********** A NEW STUDENT WAS CREATED! **********'
		else
		...

It helps to make the message stand out (as shown here with all-caps and asterisks) as the log file in *log/development.log* contains a **huge** amount of information. Now when a new student is created and saved, the above message will be added to the log file when the database transaction is complete. The message will also be displayed at the terminal that is running the Rails server.

<sup>See text for explanation of how to output specific information to the Rails log files.</sup>

####Working with Rails from the Console
<sup>See text for a detailed tutorial of how to use the Rails console to work with the application and its objects, including an explanation of how to examine individual http requests.</sup>

####Debug and Debugger
In addition to the `debug` method, which displays all of an object's attributes within the view markup, we can use the `debugger` method from the controller. Similar to the "logging" example above, open *app/controllers/students_controller.rb* and locate the **create** method (`def create...`). Just after the line that assigns the @student variable, call the debugger as follows:

		def create
			@student = Student.new(student_params)
			debugger
			respond_to do |format|
		...

Open the browser and navigate to *localhost:3000/students/new* and fill out the form to create a new student. Click "Create Student" to submit and notice that the browser's status bar will read "Waiting for localhost...". Now check the terminal window where Rails server is running and notice the `(byebug)` prompt. Enter "next" to move the code forward to the next line. 

To view the attributes of the **student** being created, enter `p @student`. Enter the `next` keyword to keep progressing through the program, `cont` to leave the debugger and let the program continue, or `quit` to leave the debugger and shut down the server. 

**NOTE:** Byebug has a wide assortment of commands to help with isolating processes or pinponting issues. Enter `help` at the `(byebug)` prompt for a complete list.

