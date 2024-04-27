import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

enum TaskCategory {
  all,
  completed,
  pending,
}

TaskCategory currentCategory = TaskCategory.all;


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBGColor,
      appBar: _buildAppBar(), //appbar widget
      body: Stack(
        //Use a stack layout to enable the add task form stack over the tasks
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 70),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(), //search widget
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                        ),
                        child: const Center(
                          child: Text(
                            'Tasks',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              // fontFamily: 'Raleway',
                            ),
                          ),
                        ),
                      ),
                      for (ToDo todo in _foundToDo
                          .reversed) // New tasks will be shown first
                        ToDoItem(
                          todo: todo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //Text Field for adding new task
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                      right: 20,
                      left: 20,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colorWhite,
                      boxShadow: const [
                        BoxShadow(
                          color: colorGrey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 5.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        hintText: 'Add a new todo task',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                //Eleveted Button for adding tasks
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorAppBar,
                      shadowColor: colorGrey,
                      minimumSize: const Size(40, 75),
                      elevation: 10,
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                        color: colorBGColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Drawer
      drawer: Drawer(
        elevation: 0,
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: colorAppBar,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/paul.jpg'),
              ),
              accountName: Text('Paul SQ Magadi'),
              accountEmail: Text('paul.learner@plp.com'),
            ),
            // List Tile inside the Drawer
            ListTile(
              title: const Text('All Tasks'),
              leading: const Icon(
                Icons.task,
                color: colorAppBar,
              ),
              onTap: () => setSelectedCategory(TaskCategory.all, context),
            ),
            ListTile(
              title: const Text('Completed Tasks'),
              leading: const Icon(
                Icons.task_alt,
                color: colorAppBar,
              ),
              onTap: () => setSelectedCategory(TaskCategory.completed, context),
            ),
            ListTile(
              title: const Text('Pending Tasks'),
              leading: const Icon(
                Icons.pending_actions,
                color: colorAppBar,
              ),
              onTap: () => setSelectedCategory(TaskCategory.pending, context),
            ),
            ListTile(
              title: const Text('About'),
              leading: const Icon(
                Icons.info,
                color: colorAppBar,
              ),
              onTap: () {
                // Navigate to the About page
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              title: const Text('Help'),
              leading: const Icon(
                Icons.help_center,
                color: colorAppBar, // Or desired color
              ),
              onTap: () {
                // Navigate to the Help page
                Navigator.pushNamed(context, '/help');
              },
            ),
            ListTile(
              title: const Text('Calendar'),
              leading: const Icon(Icons.calendar_today, color: colorAppBar),
              onTap: () {
                Navigator.pushNamed(context, '/calendar');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(
                Icons.logout,
                color: colorAppBar,
              ),
              onTap: () {
                // Handle logout action
              },
            ),
          ],
        ),
      ),
    );
  }

//Handle tasks state
  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

// Delete task
  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

//Add new task with unique id
  void _addToDoItem(String toDo) {
    setState(() {
      todosList.add(
        ToDo(
          id: DateTime.now()
              .millisecondsSinceEpoch
              .toString(), // Ensure every new task has unique id
          todoText: toDo,
        ),
      );
    });
    _todoController.clear();
  }

// Search  functionality
  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

//Search box
  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: colorBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 25,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search Task',
          hintStyle: TextStyle(color: colorGrey),
        ),
      ),
    );
  }

//Appbar
  // AppBar _buildAppBar() {
  //   return AppBar(
  //     backgroundColor: colorAppBar,
  //     foregroundColor: colorWhite, //set Text and icon colors to white
  //     title: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         const Text(
  //           "Task Master",
  //           style: TextStyle(fontSize: 28),
  //         ),
  //         Column(
  //           children: [
  //             SizedBox(
  //               // Here I use SizeBox instead of Container
  //               height: 36,
  //               width: 36,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(50),
  //                 child: Image.asset('assets/images/paul.jpg'),
  //               ),
  //             ),
  //             const Center(
  //               child: Text(
  //                 "Magadi",
  //                 style: TextStyle(fontSize: 13),
  //               ),
  //             )
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
AppBar _buildAppBar() {
    // Determine the title based on the current task category
    String title = '';
    if (currentCategory == TaskCategory.all) {
        title = 'All Tasks';
    } else if (currentCategory == TaskCategory.completed) {
        title = 'Completed Tasks';
    } else if (currentCategory == TaskCategory.pending) {
        title = 'Pending Tasks';
    }
    
    return AppBar(
        backgroundColor: colorAppBar,
        foregroundColor: Colors.white,
        title: Text(
            title,
            style: const TextStyle(fontSize: 28),
        ),
        actions: [
            // Add any additional actions (e.g., a profile picture)
            SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/images/paul.jpg'),
                ),
            ),
        ],
    );
}

//   void setSelectedCategory(TaskCategory category, BuildContext context) {
//     // Close the drawer after selection
//     Navigator.pop(context);

//     // Initialize filteredTodos
//     List<ToDo> filteredTodos = [];

//     // Filter the todo list based on the selected category
//     if (category == TaskCategory.all) {
//       filteredTodos = todosList;
//     } else if (category == TaskCategory.completed) {
//       filteredTodos = todosList.where((todo) => todo.isDone).toList();
//     } else if (category == TaskCategory.pending) {
//       filteredTodos = todosList.where((todo) => !todo.isDone).toList();
//     }

//     // Update the state with the filtered list of todo items
//     setState(() {
//       _foundToDo = filteredTodos;
//     });
//   }

void setSelectedCategory(TaskCategory category, BuildContext context) {
    // Close the drawer after selection
    Navigator.pop(context);
    
    // Update the current category and filter the tasks
    setState(() {
        currentCategory = category;

        if (category == TaskCategory.all) {
            _foundToDo = todosList;
        } else if (category == TaskCategory.completed) {
            _foundToDo = todosList.where((todo) => todo.isDone).toList();
        } else if (category == TaskCategory.pending) {
            _foundToDo = todosList.where((todo) => !todo.isDone).toList();
        }
    });
}

}
