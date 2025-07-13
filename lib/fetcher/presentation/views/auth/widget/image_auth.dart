import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/fetcher/domian/auth/auth_cubit.dart';

class ImageAuth extends StatelessWidget {
  const ImageAuth({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigApp.initConfig(context);
    double width = ConfigApp.width;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        File? imageFile;
        if (state is AuthImagePicked) {
          imageFile = state.image;
        }

        return Stack(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () {
                context.read<AuthCubit>().pickImage(title: 'Gallery');
              },
              child: CircleAvatar(
                radius: width * 0.13,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,

                backgroundImage:
                    imageFile != null ? FileImage(imageFile) : null,
                child:
                    imageFile == null
                        ? Icon(
                          Icons.add_a_photo,
                          size: width * 0.1,
                          color: Colors.grey[400],
                        )
                        : null,
              ),
            ),
            Positioned(
              bottom: -2,
              right: 0,
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.camera,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  context.read<AuthCubit>().pickImage(title: 'Camera');
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
