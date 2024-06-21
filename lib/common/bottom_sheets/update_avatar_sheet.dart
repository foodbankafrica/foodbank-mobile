import 'package:flutter/material.dart';
import 'package:food_bank/common/widgets.dart';

class UpdateAvatarBottomSheet extends StatefulWidget {
  static String name = 'select-avatar';
  static String route = '/select-avatar';
  const UpdateAvatarBottomSheet({super.key});

  @override
  State<UpdateAvatarBottomSheet> createState() =>
      UpdateAvatarBottomSheetState();
}

class UpdateAvatarBottomSheetState extends State<UpdateAvatarBottomSheet> {
  String selectImage = "avatar-1";

  _setSelectImage(path) {
    setState(
      () {
        selectImage = path;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const FoodBankBottomSheetAppBar(
          icon: SizedBox(),
          title: 'Update Avatar',
        ),
        const SizedBox(height: 8),
        const Divider(thickness: 0.5),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select your avatar',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Pick one avatar that suites your taste',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleAvatar(
                      selectImagePath: selectImage,
                      imagePath: "avatar-1",
                      onTap: (String path) => _setSelectImage(path),
                    ),
                    SingleAvatar(
                      selectImagePath: selectImage,
                      imagePath: "avatar-2",
                      onTap: (String path) => _setSelectImage(path),
                    ),
                    SingleAvatar(
                      selectImagePath: selectImage,
                      imagePath: "avatar-3",
                      onTap: (String path) => _setSelectImage(path),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleAvatar(
                      selectImagePath: selectImage,
                      imagePath: "avatar-4",
                      onTap: (String path) => _setSelectImage(path),
                    ),
                    SingleAvatar(
                      selectImagePath: selectImage,
                      imagePath: "avatar-5",
                      onTap: (String path) => _setSelectImage(path),
                    ),
                    SingleAvatar(
                      selectImagePath: selectImage,
                      imagePath: "avatar-6",
                      onTap: (String path) => _setSelectImage(path),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleAvatar(
                      selectImagePath: selectImage,
                      imagePath: "avatar-7",
                      onTap: (String path) => _setSelectImage(path),
                    ),
                    SingleAvatar(
                      selectImagePath: selectImage,
                      imagePath: "avatar-8",
                      onTap: (String path) => _setSelectImage(path),
                    ),
                    SingleAvatar(
                      selectImagePath: selectImage,
                      imagePath: "avatar-9",
                      onTap: (String path) => _setSelectImage(path),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: CustomButton(
            onTap: () {
              // context.push(UserFoodBankBottomNavigator.route);
            },
            text: 'Set Avatar',
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class SingleAvatar extends StatelessWidget {
  const SingleAvatar({
    super.key,
    required this.imagePath,
    required this.onTap,
    required this.selectImagePath,
  });
  final String imagePath, selectImagePath;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(imagePath),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: selectImagePath == imagePath
              ? Border.all(
                  width: 3,
                  color: const Color(0xFFEB5017),
                )
              : null,
          image: DecorationImage(
            image: NetworkImage(
              "https://firebasestorage.googleapis.com/v0/b/amam-appilication-store.appspot.com/o/avatar%2F$imagePath.png?alt=media&token=e39f17aa-d4e4-4d1d-9cb5-8adf712fab04",
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
