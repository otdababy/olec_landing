import 'dart:ui';
import 'package:event_page/api/event_page_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _shouldAlertError = false;
  bool isPosting = false;
  String _phnNum = '';

  final TextEditingController _phnNumController = TextEditingController();

  void handlePosting(String val) async {
    setState(() {
      isPosting = true;
      _shouldAlertError = false;
      _phnNumController.text = _phnNum;
    });

    String tmp = val.replaceAll('-', '');
    bool _isPhnNumValid = RegExp(r'^[0-9]{11}$').hasMatch(tmp);

    if (_isPhnNumValid) {
      try {
        await EventPageApi.postPhnNum(
            PhnNumPost(phoneNumber: _phnNum.replaceAll('-', ''))
        );
        setState(() {
          isPosting = false;
          _phnNum = '';
          _phnNumController.text = '';
        });
        if (!mounted) return;
        //Navigator.of(context).pushNamed('/home');
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                title: const Text('감사합니다!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500
                  ),
                ),
                content: const Text('출시 후, 다운로드 정보를 \n보내드릴게요😎',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                    )
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('확인')
                  )
                ],
              );
            }
        );
      } catch (e) {
        setState(() {
          isPosting = false;
        });
        print(e);
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                title: const Text('네트워크 에러',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                      fontWeight: FontWeight.w500
                  ),
                ),
                content: const Text('네트워크 에러가 발생하여\n잠시 후 다시 시도해 주시기 바랍니다.',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                    )
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('확인')
                  )
                ],
              );
            }
        );
      }
    } else {
      setState(() {
        isPosting = false;
        _shouldAlertError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 96
                      ),
                      child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/olec.png',
                                width: MediaQuery.of(context).size.width * 0.2,
                              ),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(26.0),
                                  child: Image.asset(
                                    'assets/images/iphone.png',
                                    width: MediaQuery.of(context).size.width * 0.65,
                                  ),
                                ),
                              ),
                              Center(
                                child: Image.asset(
                                    'assets/images/text1.png',
                                    //height:90,
                                    width: MediaQuery.of(context).size.width * 0.45,
                                ),
                              ),
                              Center(
                                child: Image.asset(
                                  'assets/images/비교그룹.png',
                                ),
                              ),
                              Column(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'assets/images/text2.png',
                                      //height:90,
                                      width: MediaQuery.of(context).size.width * 0.6,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Center(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Visibility(
                                              visible: !_shouldAlertError,
                                              replacement: SizedBox(
                                                  height: 36,
                                                  child: Column(
                                                      children: const [
                                                        Spacer(),
                                                        Text('올바른 핸드폰 번호를 입력해주세요.',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.red
                                                            )
                                                        )
                                                      ]
                                                  )
                                              ),
                                              child: const SizedBox(
                                                  height: 15
                                              )
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: SizedBox(
                                                      height: 36,
                                                      child: TextField(
                                                        enabled: !isPosting,
                                                        toolbarOptions: const ToolbarOptions(
                                                            copy: true,
                                                            cut: true,
                                                            paste: true,
                                                            selectAll: true
                                                        ),
                                                        keyboardType: TextInputType.number,
                                                        inputFormatters: [
                                                          MaskedInputFormatter('###-####-####')
                                                        ],
                                                        controller: _phnNumController,
                                                        onChanged: (val) {
                                                          _phnNum = _phnNumController.text;
                                                          setState(() {
                                                            _shouldAlertError = false;
                                                          });
                                                        },
                                                        decoration:
                                                          InputDecoration(
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: !_shouldAlertError ? Colors.black : Colors.red,
                                                                    width: 1
                                                                ),
                                                                borderRadius: BorderRadius.circular(40)
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: !_shouldAlertError ? Colors.black : Colors.red,
                                                                    width: 1
                                                                ),
                                                                borderRadius: BorderRadius.circular(40)
                                                            ),
                                                            disabledBorder: OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors.black,
                                                                    width: 1
                                                                ),
                                                                borderRadius: BorderRadius.circular(40)
                                                            ),
                                                            contentPadding: const EdgeInsets.all(12.0),
                                                            hintText: '"-" 없이 입력',
                                                            hintStyle: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.black
                                                            )
                                                        ),
                                                        cursorColor: Colors.black,
                                                        textAlign: TextAlign.left,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black
                                                        ),
                                                      )
                                                  )
                                              ),
                                              SizedBox(width: 5,),
                                              Visibility(
                                                  visible: !isPosting,
                                                  replacement: SizedBox(
                                                      height: 36,
                                                      child: TextButton(
                                                          style: ButtonStyle(
                                                              splashFactory: NoSplash.splashFactory,
                                                              backgroundColor: MaterialStateProperty.all(Colors.white),
                                                              shape: MaterialStateProperty.all(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(40)
                                                                  )
                                                              )
                                                          ),
                                                          onPressed: null,
                                                          child: const Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 22),
                                                              child: SizedBox(
                                                                  height: 18,
                                                                  width: 18,
                                                                  child: CircularProgressIndicator(
                                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                                                      strokeWidth: 2
                                                                  )
                                                              )
                                                          )
                                                      )
                                                  ),
                                                  child: SizedBox(
                                                      height: 36,
                                                      child: TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor: MaterialStateProperty.all(Color(0xff2363C2)),
                                                              shape: MaterialStateProperty.all(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(40)
                                                                  )
                                                              )
                                                          ),
                                                          onPressed: () {
                                                            handlePosting(_phnNum);
                                                          },
                                                          child: const Text('예약하기',
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.w900,
                                                                fontSize: 12
                                                            ),
                                                          )
                                                      )
                                                  )
                                              )
                                            ],
                                          )
                                        ]
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                      )
                  )
              ),
            )
        )
    );
  }
}