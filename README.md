# FetchRecipes_HEcho
 
### Summary: 
Include screen shots or a video of your app highlighting its features
| All Recipes List | Search | Detail Recipe View | Filter Menu | Search and Filter applied |
|---------|---------|---------|---------|---------|
| ![Simulator Screenshot - iPhone 16 Pro - 2025-03-03 at 19 46 24](https://github.com/user-attachments/assets/41293a22-5b56-407c-b631-64887dffb18c) | ![Simulator Screenshot - iPhone 16 Pro - 2025-03-03 at 19 47 03](https://github.com/user-attachments/assets/32f2ad0b-838f-4035-bd2b-3763b38fff97) | ![Simulator Screenshot - iPhone 16 Pro - 2025-03-03 at 19 46 52](https://github.com/user-attachments/assets/02efae29-b786-4016-aa4e-8c2f60cc0466) | ![Simulator Screenshot - iPhone 16 Pro - 2025-03-03 at 19 46 45](https://github.com/user-attachments/assets/8f2c4395-1ccf-410a-aae4-1b30b9842074) | ![Simulator Screenshot - iPhone 16 Pro - 2025-03-03 at 19 47 11](https://github.com/user-attachments/assets/f106c8db-c6ac-4ae5-9205-79d0a843775f) |

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
For this project, I focused on implementing the MVVM (Model-View-ViewModel) pattern and utilizing dependency injection to enhance testability. This approach helps maintain a clean separation of concerns and makes it easier to write unit tests for various components of the app.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
Approximately 5 hours were spent on the project:
 - 1 hour gathering requirements, planning approach, reviewing SwiftConcurrency documentation
 - 1 hour implementing foundational code, fetch data, present data in it's simplest form
 - 1 hour enhancing the UI to present the recipes, add filtering and add in viewState management
 - 1.5 hours adding test coverage and refactoring as necessary
 - .5 hr final refactors, polish, and clean up

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
For image caching, I decided to implement a solution using `NSCache` so I could leverage its built-in memory management and caching capabilities. While considering various options, I thought about using `AsyncImage` to download and display recipe images, however, `NSCache` requires `UIImage` objects. This decision was made due to my uncertainty about converting `Image` to `UIImage`, as I haven't worked with that conversion before, and I wanted to avoid potential performance or reliability issues.

### Weakest Part of the Project: What do you think is the weakest part of your project?
The weakest aspect of this project is the error handling and presentation of error or empty states. For simplicity, error handling was kept generic, but in a production environment, it should be more specific and user-friendly to guide users toward resolving issues or understanding when no data is available. The image cache could also be enhanced to add eviction rules or a mechanism to empty the cache.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
This project was built using Swift 6 and supports a minimum version of iOS 18.2. 
