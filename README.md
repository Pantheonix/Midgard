# Midgard

The Pantheonix fronted, called Midgard as the Earth name in the Germanic cosmology, is implemented as a responsive Flutter web client.

## Technologies
- Flutter 3.16
- Stacked (MVVM based Flutter framework made by FilledStacks)
- Firebase (Web Hosting)
- Rive animations

## Functionalities
**Auth**:
- login based on credentials
- bear Rive animation on login screen
- register based on credentials
- bear Rive animation on register screen

**Users**:
- user profile screen
- all users screen

**Problems**:
- full problem screen
- problem proposal screen with widgets for tweaking the problem description as markdown and uploading tests as zip archives
- all problems screen with support for pagination, filtering and sorting

**Submissions**:
- send submission widget/screen with support for tweaking the source code in an embedded code editor with syntax highlighting and choosing the programming language
- all submissions screen with support for pagination, filtering and sorting
- single submission screen with all test cases widget
## Architectures
Midgard is based on the **MVVM** (Model-View-ViewModel) architecture fostered by the Stacked framework.

Model-View-ViewModel (MVVM) is a software architectural pattern used in the development of user interfaces. It separates the concerns of the user interface into three main components: Model, View, and ViewModel. Key features of MVVM include:

1. **Model (M):** Represents the application's data and business logic. It is responsible for managing and manipulating the data, as well as notifying observers about changes. The Model is independent of the user interface.

2. **View (V):** Represents the user interface and is responsible for presenting the data to the user. In MVVM, the View is passive and does not contain any application logic. It observes the ViewModel for updates and binds to its properties.

3. **ViewModel (VM):** Acts as an intermediary between the Model and the View. It exposes the data and commands needed by the View, adapting the Model's data into a form that is easily consumable by the View. The ViewModel often implements interfaces or uses data-binding to enable communication with the View.

4. **Data Binding:** A key feature of MVVM is the use of data binding, which establishes a connection between the View and the ViewModel. Changes in the ViewModel automatically update the View, and user interactions in the View can update the ViewModel.

5. **Two-Way Data Binding:** Allows changes in the View to automatically update the ViewModel and vice versa. This bidirectional communication simplifies the synchronization of data between the user interface and the application logic.

6. **Command Pattern:** ViewModel exposes commands that can be bound to UI elements (like buttons). These commands invoke specific actions in response to user interactions, enabling a separation of concerns and improved testability.

7. **Testability:** MVVM promotes a design that facilitates unit testing. Since the business logic is encapsulated in the ViewModel, it can be tested independently of the user interface.

8. **Decoupling:** MVVM fosters a clear separation of concerns, reducing dependencies between components. This separation enhances maintainability and allows for more modular and scalable development.

9. **Services**: while the presentation logic is hold by the ViewModels layer, the actual business logic is maintained in a dedicated Services layer which communicates with 3rd-party APIs
