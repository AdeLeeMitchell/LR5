#LR5
##Chapter 10
###"Managing Databases with Migrations"

A migration is a set of instructions for changing, adding, or removing database structures in a Rails application. Migrations are implemented and rolled back using specific `rake` commands. The application for this chapter, *migrationTester*, contains a variety of migration examples which are located in the *db/migrate* directory.

#####"Migration Files"

To generate a new migration, use the command syntax `rails generate migration NameOfMigration` in the terminal. It is helpful to choose a semantic, meaningful name for the migration to help find it later. The name can be in *CamelCase* or with *underscores_between_words*. Either way, Rails will understand and append it to a timestamp. 

A basic, empty migration created with the command `rails g migration EmptyMigration` will create a following migration file (*db/migrate/20151110005156_empty_migration.rb*) with the following code:

		class EmptyMigration < ActiveRecord::Migration
			def change
			end
		end

As shown in Chapter 9, creating tables complete with columns and data types is fairly simple using migrations. At the time of this writing, the **change** method supports the following definitions, which Rails knows how to "reverse" should the migration be rolled back:

		add_column
		add_foreign_key
		add_index
		add_reference
		add_timestamps
		change_column_default (must supply a :from and :to option)
		change_column_null
		create_join_table
		create_table
		disable_extension
		drop_join_table
		drop_table (must supply a block)
		enable_extension
		remove_column (must supply a type)
		remove_foreign_key (must supply a second table)
		remove_index
		remove_reference
		remove_timestamps
		rename_column
		rename_index
		rename_table

**NOTE:** When using any other definitions in a migration (the use of executable SQL statements for instance), the following syntax can be used instead of the **change** method:

		class MigrationName < ActiveRecord::Migration
			def self.up
				# some irreversible method
			end

			def self.down
				# opposite of irreversible method
			end
		end

#####"Inside Migrations"

When Rails *scaffolding* is used to generate the model, controller, and views for an object a migration is also generated. For example, the following migration was created in Chapter 9 with the **scaffolding** command:

		class CreateStudents < ActiveRecord::Migration
			def change
				create_table :students do |t|
					t.string :given_name
					t.string :middle_name
					t.string :family_name
					t.date :date_of_birth
					t.decimal :grade_point_average
					t.date :start_date

					t.timestamps
				end
			end
		end

Running this migration to add the **Student** model to the schema was simple, using the command `rake db:migrate`. Since Rails is able to reverse the **create_table** method, it can be removed by running `rake db:rollback`.

Migrations can be plain and empty or more robust. The following migration would build a migration with an empty table called "Books"...

		rails generate migration CreateBook

This produces a file (*db/migrate/20151110012135_create_book.rb*) with the following code:

		class CreateBook < ActiveRecord::Migration
			def change
				create_table :books do |t|
				end
			end
		end

The columns may then be added within the **create_table** method, as above, prefixed with **t.**

Just as columns can be added to a migration generated with scaffolding, these attributes can also be specified when generating a simple table like the one above. The following command generates the **Books** table with some basic columns:

		rails generate migration CreateBookWithColumns title:string author:string isbn:integer price:float published_date:date

..which produces the following migration file (*db/migrate/20151117015213_create_book_with_columns*):

		class CreateBookWithColumns < ActiveRecord::Migration
			def change
				create_table :book_with_columns do |t|
					t.string :title
					t.string :author
					t.integer :isbn
					t.float :price
					t.date :published_date
				end
			end
		end

#####"Data Types"

Before a migration is run, named parameters can be added to columns depending on their data type. For example, one might edit the preceding migration to read as follows:

		class CreateBookWithColumns < ActiveRecord::Migration
			def change
				create_table :book_with_columns do |t|
					t.string :title, limit: 100 ### entries will be limited to 100 characters and cannot be left empty
					t.string :author, limit: 45 ### entries will be limited to 45 characters
					t.integer :isbn, limit: 13 ### entries will be limited to 13 characters
					t.decimal :price, precision: 6, scale: 2 ### entries will follow the format "xxxx.xx"
					t.date :published_date, default: Date.today ### this sets the default value to today's date. However, this is not automatically persisted to the model and will be overwritten with user-entered data.
				end
			end
		end

#####"Working with Columns"

Once the application has been established, table columns may still be added, removed, or changed with a standalone migration. For instance, if the **Books** table created in the previous section needed to specify the language in which books are written, simply create a migration with `rails g migration AddLanguageToBooks language:string`, which creates the following file (*20151119000940_add_language_to_book.rb*):

		class AddLanguageToBook < ActiveRecord::Migration
			def change
				add_column :books, :language, :string
			end
		end

Columns that are deemed to be unnecessary can be removed in similar fashion. A command such as the following will do the trick: `rails g migration RemovePublished_dateFromBooks published_date:date`. The following file is created (*201511190001942_remove_published_date_from_books.rb*):

        class RemovePublishedDateFromBooks < ActiveRecord::Migration
          def change
            remove_column :books, :published_date, :date
          end
        end

There are also "plural" versions of these methods - **add_columns** and **remove_columns** to speed up the alteration of multiple columns at once. Similarly, existing columns can easily be changed. For example, if the price of books were to skyrocket, one could create a migration with `rails g migration alter_column_books_price`. This will generate a migration file with an empty **change** method, wherein the column may be redefined (*20151119004306_alter_column_books_price.rb*)...

        class AlterColumnBooksPrice < ActiveRecord::Migration
          def change
            change_column :books, :price, precision: 7, scale: 2
          end
        end


There are a multitude of instance methods and transformations available for ActiveRecord migrations. More information can be found at *http://edgeguides.rubyonrails.org/active_record_migrations.html* and *http://apidock.com/rails/ActiveRecord/Migration*.



		