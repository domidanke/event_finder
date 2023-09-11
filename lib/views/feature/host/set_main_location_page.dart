import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/popup.service.dart';
import 'package:event_finder/services/search_page.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/shared/search_address_in_map.dart';
import 'package:event_finder/widgets/custom_button_async.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../../widgets/custom_icon_button.dart';

class SetMainLocationPage extends StatefulWidget {
  const SetMainLocationPage({Key? key}) : super(key: key);

  @override
  State<SetMainLocationPage> createState() => _SetMainLocationPageState();
}

class _SetMainLocationPageState extends State<SetMainLocationPage> {
  GeoFirePoint? _selectedCoordinates;
  bool _isSaving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CustomIconButton(
                      onPressed: () {
                        SearchService().searchText = '';
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: SearchAddressInMap(
                  onAddressSelected: (GeoFirePoint geoFirePoint) {
                    setState(() {
                      _selectedCoordinates = geoFirePoint;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Opacity(
                opacity: _selectedCoordinates == null ? 0.4 : 1,
                child: SizedBox(
                  width: 120,
                  child: CustomButtonAsync(
                    onPressed: () async {
                      if (_selectedCoordinates == null) return;
                      setState(() {
                        _isSaving = true;
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                      await UserDocService()
                          .saveMainLocationData(_selectedCoordinates!);
                      await StateService().getCurrentUserSilent();
                      setState(() {
                        _isSaving = false;
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            PopupService()
                                .getCustomSnackBar('Location geändert'));
                        SearchService().searchText = '';
                        Navigator.pop(context);
                      }
                    },
                    buttonText: 'Speichern',
                    loading: _isSaving,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
