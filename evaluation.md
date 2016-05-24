#### Evaluation Rubric - Rush Hour

The project will be assessed with the following rubric:

##### 1. Functional Expectations

3: Application fulfills base expectations

##### 2. Test-Driven Development

3: Application is well tested but does not balance isolation and integration/feature tests

##### 3. Encapsulation / Breaking Logic into Components

3: Application effectively breaks logical components apart but breaks the principle of SRP

##### 4. Fundamental Ruby & Style

4: Application demonstrates excellent knowledge of Ruby syntax, style, and refactoring

##### 5. Sinatra / Web and Business Logic

3: Application makes good use of Sinatra but has some mixing of the web and business logic.

##### 6. View Layer

3: Application breaks components out to view partials but has some logic or complexity leaking into the view

##### Workflow (NOT GRADED)

3: Good use of branches, pull requests, and a project-management tool.


###### Notes:

- In the response data: The response times should be unique.
- The controller could be broken up into smaller components. We also have nested conditionals which says that we could restructure that section.
- Some logic is in the controller that could be pulled out.
- To make a robust test helper, we could do all the payload creation before bringing it to the test.
- We are hard-coding the client id as well, which doesn't cause issues at the moment but could. Create the client when creating the payload and pass the actual client id in, not just the integer 1. This shows we are not using activerecord to its fullest potential.
- By creating the entire payload outside of the test is less expensive than creating it in every test. We should also create and analyze the raw payload in the test helper before the test.
- The test helper could also have a default payload and if we want to change specific attributes, we could pass them in instead of creating specific payloads for specific instances.
- In our payload request test, we asserted that the count of the payloads was zero in tests that it was unnecessary in. Since we have tested that the payload can be created, there is no need to test the count of the payloads until after the data has been saved to the database.
- What we called the Payload Analyzer may be described in a better way because it doesn't analyze the data but "handles" it. Could rethink some variable and method names as well.
- Work to understand activerecord relationships and how you can call clients' payloads in a direct way.
- Feature testing was missing for user can see all events.
- Feature testing could be more specific by testing certain html elements on the page. There might be an overlap where the same phrase appears in more than one place on the page so be as specific as possible.
- We checked the validity of our tables by creating an instance and we could have just made an instance that we didn't save.
- The tests were robust and tested edge cases but included too much information. Be careful about how many instances are created and why they are necessary.
- To get a 4 on testing, we needed to have our event feature test and some of our data would need to be restructured.
- Our accessors in some of the classes are not being utilized.
- There were instances that we hard-coded the first position in the array ([0]) and there are activerecord methods such as find_by that would allow us to access that position without hard-coding.
- We could have utilized partial views for some of our views such as all the index which could be interpolated.
- We could capitalize our html in a method and pass it to our views instead of directly in the views.
- Work flow was good but we could have used the comments more throughout the project when merging.
