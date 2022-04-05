//void bottomSheets(context, imagesDataModel) {
//  showModalBottomSheet(
//      backgroundColor: Colors.transparent,
//      context: context,
//      builder: (context) {
//        return Container(
//          decoration: const BoxDecoration(
//            color: Colors.white,
//            borderRadius: BorderRadius.only(
//              topLeft: Radius.circular(25.0),
//              topRight: Radius.circular(25.0),
//            ),
//          ),
//          child: Wrap(
//            children: [
//              Padding(
//                padding: const EdgeInsets.all(20.0),
//                child: Text(
//                  imagesDataModel.name,
//                  style: const TextStyle(fontSize: 16.0),
//                ),
//              ),
//              Container(
//                alignment: Alignment.center,
//                child: const Divider(
//                  color: Colors.black54,
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(bottom: 5.0),
//                child: Padding(
//                  padding: const EdgeInsets.all(18.0),
//                  child: Row(
//                    children: const [
//                      Icon(
//                        Icons.delete,
//                        color: Colors.red,
//                      ),
//                      SizedBox(
//                        width: 40,
//                      ),
//                      Text(
//                        'Delete',
//                        style: TextStyle(color: Colors.black54),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(18.0),
//                child: Row(
//                  children: const [
//                    Icon(
//                      Icons.edit,
//                      color: Colors.black54,
//                    ),
//                    SizedBox(
//                      width: 40,
//                    ),
//                    Text(
//                      'Edit',
//                      style: TextStyle(color: Colors.black54),
//                    ),
//                  ],
//                ),
//              ),
//              const SizedBox(
//                height: 100,
//              ),
//            ],
//          ),
//        );
//      });
//}

//void AddImageBottomSheets(context) {
//  showModalBottomSheet(
//      backgroundColor: Colors.transparent,
//      context: context,
//      builder: (context) {
//        return Container(
//          decoration: const BoxDecoration(
//            color: Colors.white,
//            borderRadius: BorderRadius.only(
//              topLeft: Radius.circular(25.0),
//              topRight: Radius.circular(25.0),
//            ),
//          ),
//          child: Wrap(
//            children: [
//              const Padding(
//                padding: EdgeInsets.all(20.0),
//                child: Text(
//                  'ADD ITEM',
//                  style: TextStyle(fontSize: 16.0),
//                ),
//              ),
//              Container(
//                alignment: Alignment.center,
//                child: const Divider(
//                  color: Colors.black54,
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(bottom: 5.0),
//                child: Padding(
//                  padding: const EdgeInsets.all(18.0),
//                  child: GestureDetector(
//                    onTap: () {
//                      pickImage(ImageSource.camera);
//                    },
//                    child: Row(
//                      children: const [
//                        Icon(
//                          Icons.photo_camera,
//                          color: Colors.black54,
//                        ),
//                        SizedBox(
//                          width: 40,
//                        ),
//                        Text(
//                          'Open Camera',
//                          style: TextStyle(color: Colors.black54),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(18.0),
//                child: GestureDetector(
//                  onTap: () {
//                    pickImage(ImageSource.gallery);
//                  },
//                  child: Row(
//                    children: const [
//                      Icon(
//                        Icons.collections,
//                        color: Colors.black54,
//                      ),
//                      SizedBox(
//                        width: 40,
//                      ),
//                      Text(
//                        'Select from your gallery',
//                        style: TextStyle(color: Colors.black54),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              const SizedBox(
//                height: 100,
//              ),
//            ],
//          ),
//        );
//      });
//}
