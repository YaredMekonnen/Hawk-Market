import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawk_app/commons/widgets/textfield.dart';
import 'package:hawk_app/create_product/blocs/create_product_bloc/create_product_bloc.dart';
import 'package:hawk_app/create_product/models/tag.dart';
import 'package:hawk_app/create_product/widgets/item_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateProductPage extends StatefulWidget {
  
  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {

  final MultiSelectController tagsController = MultiSelectController();
  final TextEditingController tagsTextController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<XFile> _imageList = [];

  pickImage() async {
    _imageList = await ImagePicker().pickMultiImage();
    setState(() {
      _imageList = _imageList;
    });
  }

  removeImage(int index) {
    setState(() {
      _imageList.removeAt(index);
    });
  }

  saveProduct() {
    context.read<CreateProductBloc>().add(CreateProduct(
      tags: tagsTextController.text,
      name: itemNameController.text,
      description: descriptionController.text,
      price: num.parse(priceController.text),
      images: _imageList
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary
              ),
              child: Text(
                'Discard',
                style: TextStyle(
                  color: const Color.fromARGB(255, 214, 70, 59),
                  fontSize: 3.5.w
                )
              )
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 40, 39, 39),
                  fontSize: 4.w
                )
              ),
              onPressed: () {
                saveProduct();
              },
              child: BlocBuilder<CreateProductBloc, CreateProductState>(
                builder: (context, state) {
                  if (state is CreateProductLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is CreateProductSuccess) {
                    return Text(
                      'Success',
                      style: TextStyle(
                        color: Color.fromARGB(255, 40, 39, 39),
                        fontSize: 4.w
                      )
                    );
                  } else if (state is CreateProductFailure) {
                    return Text(
                      'Failed',
                      style: TextStyle(
                      color: Color.fromARGB(255, 40, 39, 39),
                      fontSize: 4.w
                    )
                    );
                  }
                  return Text(
                    'Post',
                    style: TextStyle(
                      color: Color.fromARGB(255, 40, 39, 39),
                      fontSize: 4.w
                    )
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 23.w,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 5.w),
              constraints: BoxConstraints(maxWidth: 100.w, maxHeight: 23.w),
              child: _imageList.isNotEmpty ? ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => ItemPhoto(image: _imageList[index], removeImage: () => removeImage(index)),
                separatorBuilder: (context, index) => SizedBox(width: 3.w),
                itemCount: _imageList.length,
              ) :
              Text('Select a Photo', style: Theme.of(context).textTheme.bodyMedium)
            ),
            SizedBox(height: 5.w),
            GestureDetector(  
              onTap: pickImage,
              child: Container(
                width: 30.w,
                height: 27.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5.w,
                        blurRadius: 1.w,
                      ),
                    ],
                  borderRadius: BorderRadius.circular(5.w)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, color: Theme.of(context).colorScheme.secondary),
                    SizedBox(height: 3.w),
                    Text('Add Photos', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.w),
            // Container(
            //   constraints: BoxConstraints(maxWidth: 90.w),
            //   child: MultiSelectDropDown(
            //     controller: tagsController,
            //     onOptionSelected: (List<ValueItem> selectedTags) {
            //       print(selectedTags);
            //     }, 
            //     options: [
            //       ValueItem(label: 'Option 1', value: '1'),
            //       ValueItem(label: 'Option 2', value: '2'),
            //       ValueItem(label: 'Option 3', value: '3'),
            //       ValueItem(label: 'Option 4', value: '4'),
            //       ValueItem(label: 'Option 5', value: '5'),
            //       ValueItem(label: 'Option 6', value: '6'),
            //     ],
            //     padding: EdgeInsets.symmetric(vertical: 2.5.w),
            //     selectionType: SelectionType.multi,
            //     chipConfig: const ChipConfig(wrapType: WrapType.wrap),
            //     dropdownHeight: 60.w,
            //     optionTextStyle: Theme.of(context).textTheme.bodyMedium,
            //     optionsBackgroundColor: Theme.of(context).colorScheme.background,
            //     selectedOptionIcon: const Icon(Icons.check, color: Colors.white),
            //     inputDecoration: BoxDecoration(
            //       color: Theme.of(context).colorScheme.background,
            //       borderRadius: BorderRadius.circular(3.w),
            //       border: Border.all(color: Theme.of(context).colorScheme.secondary),
            //     ),
            //   ),
            // ),
            CustomeTextField(hintText: 'Tags', controller: tagsTextController, inputType: TextInputType.number,),
            SizedBox(height: 5.w),
            CustomeTextField(hintText: 'Item Name', controller: itemNameController),
            SizedBox(height: 5.w),
            CustomeTextField(
              hintText: 'Description',
              controller: descriptionController, 
              lines: 5,
              labelText: '\n\n\n',
            ),
            SizedBox(height: 5.w),
            CustomeTextField(hintText: 'Price', controller: priceController),
            SizedBox(height: 30.w),
          ],
        ),
      ),
    );
  }

}