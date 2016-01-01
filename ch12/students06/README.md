#LR5
##Chapter 12 - Testing
####Test Mode

Rails applications can be run in 3 modes, or "environments": **Development**, **Test**, and **Production**. To switch from the default mode, _development_, to _test_ mode, issue the following command at the terminal command prompt:

		rails server -e test

####Setting Up a Test Database with Fixtures

**Fixtures** allow developers to define stable data for use in the test database. Fixtures are written in YAML and the Rails scaffolding generator provides us with the basic files in the _test/fixtures_ directory. 

Open _test/fixtures/students.yml_ in the text editor and change the existing generic fixtures to read as follows:

    magnum:
      given_name: Thomas
      middle_name: Sullivan
      family_name: Magnum
      date_of_birth: 1945-01-29
      grade_point_average: 2.92
      start_date: 1988-09-12

    rick:
      given_name: Orville
      middle_name: Wilbur
      family_name: Richard
      date_of_birth: 1943-07-23
      grade_point_average: 3.94
      start_date: 1988-09-12

    tc:
      given_name: Theodore
      middle_name:
      family_name: Calvin
      date_of_birth: 1939-12-18
      grade_point_average: 3.76
      start_date: 1988-09-12

These values, although obviously made-up, more closely represent those expected from our application. Likewise, update the _test/fixtures/awards.yml_ file with the following fixture data:

    pi:
      name: Private Investigator
      year: 1988
      student: magnum

    pilot:
      name: Helicopter Pilot - Island Hoppers
      year: 1990
      student: tc

    owner:
      name: King Kamehameha Club
      year: 1989
      student: rick

Finally, edit the contents of _test/fixtures/courses.yml_ like so:

    surveillance:
      name: Escape and Evasion
      students: magnum, rick

    security:
      name: "Personal and private property security"
      students: magnum, rick

    aviation:
      name: "Aviation Safety"
      students: tc
