import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/commons/utils/validators.dart';
import 'package:hawk_app/commons/widgets/button-text.dart';
import 'package:hawk_app/commons/widgets/progress_indecator.dart';
import 'package:hawk_app/commons/widgets/textfield.dart';
import 'package:hawk_app/create_product/blocs/create_product_bloc/create_product_bloc.dart';
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
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();

  List<XFile> _imageList = [];
  var showImageError = false;

  pickImage() async {
    List<XFile> images = await ImagePicker().pickMultiImage();
    setState(() {
      _imageList.addAll(images);
    });
  }

  removeImage(int index) {
    setState(() {
      _imageList.removeAt(index);
    });
  }

  saveProduct() {
    if (_formKey.currentState!.validate()) {
      context.read<CreateProductBloc>().add(SaveProduct(
          tags: tagsController.selectedOptions.toString(),
          name: itemNameController.text,
          description: descriptionController.text,
          price: num.parse(priceController.text),
          images: _imageList));
    }
  }

  resetForm() {
    tagsController.clearAllSelection();
    itemNameController.clear();
    descriptionController.clear();
    priceController.clear();
    _imageList.clear();
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomeTextField(
                    hintText: 'Item Name',
                    controller: itemNameController,
                    validator: textValidator,
                  ),
                  SizedBox(height: 5.w),
                  CustomeTextField(
                    hintText: 'Description',
                    controller: descriptionController,
                    lines: 5,
                    labelText: '\n\n\n',
                    validator: discriptionValidator,
                  ),
                  SizedBox(height: 5.w),
                  CustomeTextField(
                    hintText: 'Price',
                    controller: priceController,
                    validator: priceValidator,
                    inputType: TextInputType.number,
                  ),
                  SizedBox(height: 5.w),
                  Container(
                    constraints: BoxConstraints(maxWidth: 90.w),
                    child: MultiSelectDropDown(
                      controller: tagsController,
                      onOptionSelected: (List<ValueItem> selectedTags) {},
                      options: [
                        ValueItem(label: 'Pc', value: '1'),
                        ValueItem(label: 'Mac', value: '2'),
                        ValueItem(label: 'Phone', value: '3'),
                        ValueItem(label: 'Glass', value: '4'),
                        ValueItem(label: 'Electronics', value: '5'),
                        ValueItem(label: 'Furniture', value: '6'),
                      ],
                      clearIcon: Icon(
                        Icons.close_outlined,
                        size: 0,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 2.5.w, horizontal: 2.5.w),
                      selectionType: SelectionType.multi,
                      chipConfig: ChipConfig(
                          deleteIconColor:
                              Theme.of(context).colorScheme.secondary,
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          radius: 2.w,
                          wrapType: WrapType.scroll,
                          labelColor: Theme.of(context).colorScheme.primary),
                      dropdownHeight: 60.w,
                      optionTextStyle: Theme.of(context).textTheme.bodyMedium,
                      optionsBackgroundColor:
                          Theme.of(context).colorScheme.background,
                      selectedOptionBackgroundColor:
                          Theme.of(context).colorScheme.background,
                      selectedOptionIcon: Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      inputDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(3.w),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.w),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: IconButton(
                iconSize: 10.w,
                onPressed: pickImage,
                color: Theme.of(context).colorScheme.background,
                icon: const Icon(Icons.add),
              ),
            ),
            SizedBox(height: 5.w),
            Container(
              height: 23.w,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 5.w),
              constraints: BoxConstraints(maxWidth: 100.w, maxHeight: 23.w),
              child: _imageList.isNotEmpty
                  ? Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: ListView.separated(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => ItemPhoto(
                            image: _imageList[index],
                            removeImage: () => removeImage(index)),
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 3.w),
                        itemCount: _imageList.length,
                      ),
                    )
                  : !showImageError
                      ? Text('Select a photo',
                          style: Theme.of(context).textTheme.bodyMedium)
                      : Text('Please Select at least one photo',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: const Color.fromARGB(255, 214, 70, 59),
                                  fontSize: 4.w)),
            ),
            SizedBox(height: 5.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      child: Text('Discard',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: const Color.fromARGB(255, 214, 70, 59),
                                  fontSize: 5.w))),
                  BlocBuilder<CreateProductBloc, CreateProductState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: state is CreateProductLoading ||
                                state is CreateProductSuccess
                            ? null
                            : () {
                                if (_imageList.isEmpty) {
                                  setState(() {
                                    showImageError = true;
                                  });
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  _confirmationDialog(context);
                                }
                              },
                        child: state is CreateProductLoading
                            ? ButtonProgress()
                            : state is CreateProductSuccess
                                ? ButtonText(text: 'Success')
                                : state is CreateProductFailure
                                    ? ButtonText(text: 'Faild')
                                    : ButtonText(text: 'Post'),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }

  _confirmationDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        key: const Key("message dialog"),
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: Container(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.w),
              Container(
                height: 30.w,
                width: 30.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15.w),
                ),
                child: Image(
                  image: AssetImage('assets/vectors/check.png'),
                  width: 10.w,
                  height: 10.w,
                ),
              ),
              SizedBox(height: 5.w),
              Text(
                'To post items you need to pay \$1. Do you want to continue?',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 7.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Text('Discard',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.background)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      saveProduct();
                      GoRouter.of(context).go('/payment');
                    },
                    child: Text('Continue',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.background)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
