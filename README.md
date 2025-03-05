# FetchRecipes_HEcho
 
### Summary: 
Include screen shots or a video of your app highlighting its features

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
For this project I prioritized using the MVVM pattern as well as dependency injection for testabililty

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
Approximately 5 hours were spent on the project:
1 hour gathering requirements, planning approach, reviewing SwiftConcurrency documentation
1 hour implementing foundational code, fetch data, present data in it's simplest form
1 hour enhancing the UI to present the recipes, add filtering and add in viewState management
1.5 hours adding test coverage and refactoring as necessary
.5 hr final refactors, polish, and clean up

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
I considered using AsyncImage to download the recipe images, though the Image caching solution that I created stored UIImages and I was not comfortable with the conversion of Image to UIImage as I haven't done that conversion before and I'm unsure of the performance or related risks.

### Weakest Part of the Project: What do you think is the weakest part of your project?
The weakest part of the project is the error handling and presentation of error and empty states. For the sake of this project they were kept generic but in a production environment should be more specific and helpful to the end user.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
