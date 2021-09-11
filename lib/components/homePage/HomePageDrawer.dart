import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/ad_id_units/ad_id_units..dart';
import 'package:flutter_application_1/theming.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePageDrawer extends StatefulWidget {
  HomePageDrawer({
    required this.removeValue,
    required this.setStateToEnter,
    required this.userInfo,
    required this.storage,
  });
  final Function(String) removeValue;
  final VoidCallback setStateToEnter;
  final Map<String, dynamic> userInfo;
  final FlutterSecureStorage storage;
  @override
  _HomePageDrawerState createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  late InterstitialAd _interstitialAd;
  late bool _isInterstitialAdReady = false;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdIdUnits.bannerAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(
            () {
              this._interstitialAd = ad;
              this._isInterstitialAdReady = true;
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          setState(
            () {
              this._isInterstitialAdReady = false;
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    _loadInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }

  Widget formatDate(String dateString) {
    var date = DateTime.parse(dateString);
    return Text(
      DateFormat('dd-MM-yyyy').format(date),
    );
  }

  bool themeToBoolean(ThemeChanger themechanger) {
    if (themechanger.getTheme == ThemeMode.dark) {
      return true;
    }
    return false;
  }

  toggleTheme(bool value, ThemeChanger themechanger) async {
    if (value == true) {
      themechanger.setTheme(ThemeMode.dark);
      await widget.storage.write(key: 'isDarkModeOn', value: 'true');
    } else {
      themechanger.setTheme(ThemeMode.light);
      await widget.storage.write(key: 'isDarkModeOn', value: 'false');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        Center(
                          child: SvgPicture.asset(
                            'assets/icon.svg',
                            height: 40,
                            width: 40,
                            color: Theme.of(context).buttonColor,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Better Notes',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text('Account: '),
                            Text(
                              '@${widget.userInfo["username"]}',
                              style: TextStyle(color: Theme.of(context).buttonColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                ),
                SwitchListTile(
                    secondary: Icon(
                      Icons.brightness_2_outlined,
                    ),
                    title: Text(
                      'Dark mode',
                    ),
                    value: themeToBoolean(themeChanger),
                    onChanged: (bool value) {
                      HapticFeedback.vibrate();
                      toggleTheme(value, themeChanger);
                    }),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: Text(
                    'Log out',
                  ),
                  onTap: () async {
                    HapticFeedback.vibrate();
                    await widget.removeValue('authToken');
                    widget.setStateToEnter();
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.money,
                  ),
                  title: Text(
                    'Watch ad to support',
                  ),
                  onTap: () {
                    if (this._isInterstitialAdReady) {
                      this._interstitialAd.show();
                      this._loadInterstitialAd();
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Better Notes v1.0.0+1',
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
