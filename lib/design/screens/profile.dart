import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/constants/size_config.dart';
import 'package:todo_app/logic/controllers/task_controller.dart';
import 'package:todo_app/logic/models/user.dart';
import 'package:todo_app/logic/services/user_data.dart';

import '../../logic/services/notification_services.dart';
import '../../logic/services/theme_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController userName = TextEditingController();
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    User currentUser = UserData().loadUser();
    TextStyle style1 = Theme.of(context).textTheme.titleMedium!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: context.theme.iconTheme.color),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              ThemeServices().switchTheme();
            },
            icon: Icon(
              Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color: context.theme.iconTheme.color,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(30),
              height: SizeConfig.screenHeight * 0.45,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                const Spacer(flex: 3),
                //Profile picture
                CircleAvatar(
                  backgroundImage:
                      AssetImage(User.profilePictures[currentUser.profilePic]),
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: SizeConfig.orientation == Orientation.portrait
                      ? SizeConfig.screenWidth * 0.2
                      : SizeConfig.screenHeight * 0.2,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 4,
                          )),
                      child: IconButton(
                        icon:
                            const Icon(Icons.edit_rounded, color: Colors.white),
                        onPressed: () async {
                          await Get.bottomSheet(
                            StatefulBuilder(
                              builder: (context, setState) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Choose picture',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                    const Divider(),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: User.profilePictures.map(
                                          (image) {
                                            int index = User.profilePictures
                                                .indexOf(image);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedImage = index;
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      selectedImage == index
                                                          ? Colors.green
                                                          : Theme.of(context)
                                                              .primaryColor,
                                                  backgroundImage:
                                                      AssetImage(image),
                                                  radius: 40,
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Spacer(),
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                side: BorderSide(
                                                    width: 3,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error)),
                                            child: Text('Cancel',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                            onPressed: () => Get.back(),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                side: const BorderSide(
                                                    width: 3,
                                                    color: Colors.green)),
                                            child: Text('Confirm',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                            onPressed: () {
                                              setState(() {
                                                currentUser.profilePic =
                                                    selectedImage;
                                              });
                                              UserData().saveData(currentUser);
                                              Get.back();
                                            },
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            elevation: 5,
                            barrierColor: Get.isDarkMode
                                ? Colors.white12
                                : Colors.black26,
                          );
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                //Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentUser.userName == ''
                          ? 'Default User'
                          : currentUser.userName,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(width: 15),
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon:
                            const Icon(Icons.edit_rounded, color: Colors.white),
                        onPressed: () {
                          Get.bottomSheet(
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.25,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Change user name', style: style1),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: TextFormField(
                                      controller: userName,
                                      decoration: const InputDecoration(
                                        hintText: 'enter your name',
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      Expanded(
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              side: BorderSide(
                                                  width: 3,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error)),
                                          child: Text('Cancel',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                          onPressed: () => Get.back(),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Colors.green)),
                                          child: Text('Confirm',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                          onPressed: () {
                                            if (userName.text
                                                .trim()
                                                .isNotEmpty) {
                                              setState(() {
                                                currentUser.userName =
                                                    userName.text;
                                              });
                                              UserData().saveData(currentUser);
                                              Get.back();
                                            }
                                          },
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            elevation: 10,
                            barrierColor: Get.isDarkMode
                                ? Colors.white12
                                : Colors.black26,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                //Delete all tasks
                Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 3,
                  child: ListTile(
                    title: const Text('Delete all tasks'),
                    tileColor: Theme.of(context).colorScheme.error,
                    trailing: const Icon(Icons.cleaning_services_rounded),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onTap: () {
                      TaskController().deleteAllTasks();
                      NotifyHelper().cancelAllNotification();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                //Reset user data
                Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 3,
                  child: ListTile(
                    title: const Text('Reset user data'),
                    tileColor: Theme.of(context).colorScheme.error,
                    trailing: const Icon(Icons.remove_circle_rounded),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onTap: () {
                      setState(() {
                        UserData().resetData();
                      });
                    },
                  ),
                ),
                const Spacer(flex: 9),
              ],
            ),
          ),
        ],
      )),
    );
  }

  images(BuildContext context, int index, bool selected) {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 35,
        backgroundImage: AssetImage(User.profilePictures[index]),
        child: selected
            ? const Icon(Icons.done_rounded, color: Colors.white)
            : null,
      ),
      onTap: () {
        setState(() {});
      },
    );
  }
}
