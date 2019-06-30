import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _carplateController = TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  double searchHitBoxPos = -99999.0;
  static String _carPlate = '粤';

  @override
  void initState() {
    super.initState();
    _getLocalCarPlate();
  }

  void _getLocalCarPlate() {
SharedPreferences.getInstance().then((prefs){
  if(prefs.getString('car_plate') != null) {
    setState(() {
      _carPlate = prefs.getString('car_plate');
    });
  } else {
    setState(() {
       _carPlate = '粤';
    });
   
  }
});
  }
  @override
  void dispose(){
    super.dispose();
    _carplateController.dispose();
    _driverNameController.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Stack(
      children: <Widget>[
 Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      height: 800.0,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey),
           bottom: BorderSide(color: Colors.grey)
        )
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child:  Text('司机'),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                        onChanged: (value) {
                          if(value != '') {
                            setState(() {
                              searchHitBoxPos = 42.0;
                            });
                          } else {
                            setState(() {
                              searchHitBoxPos = -9999.0;
                            });
                          }
                        },
                        decoration: InputDecoration(
                                              hintText: '请输入司机',
                                              border: InputBorder.none),
                        controller: _driverNameController,
                        
                                      ),
                                      )
                                    
                                    ],
                                  ),
                                ),
          Container(
            child: Row(
              children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child:  Text('车牌号'),
                      ),                   
                CarSelect(
                  _carPlate,
                  (value) {
                  setState(() {
                     _carPlate = value;
                  });
                 
                })
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '请输入车牌号',
                        border: InputBorder.none),
                  controller: _carplateController,
                ),
                    )
                    ,
                  )
               
              ],
            ),
          )
          
          ,RaisedButton(
            onPressed: () {
              print('$_carPlate${_carplateController.text}');
            },
            child: Text('查询'),
          )
        ],
      ),
    ),
Positioned(
      left: 66.0,
      right: 0,
      top: searchHitBoxPos,
      child: ConstrainedBox(
        constraints: new BoxConstraints(
            maxHeight: 300.0,
  ),
        
        child:Container(
          decoration: BoxDecoration(
          color: Colors.white
        ),
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {              
                  setState(() {
                      _driverNameController.text = '$index====';
                    _driverNameController.selection = TextSelection.collapsed(offset:_driverNameController.text.length);
                    searchHitBoxPos = -99999.0;
                  });
                   
                },
                child: Text('$index'),
              ),
            );
          },
        ),
        ),
      ),
    )
      ],
    )
   ;
  }
}

class CarSelect extends StatefulWidget {
  final String _selectedValue;
  final ValueChanged valueChanged;

CarSelect(this._selectedValue, this.valueChanged);

  @override
  CarSelectState createState() => CarSelectState();
}

class CarSelectState extends State<CarSelect> {
  
  List<String> _carPlate = [
    '京','津', '泸', '渝', '蒙', '新', '藏', '宁', '桂', '黑', '吉', '辽', '晋', '冀', '青', '鲁', '豫', '苏', '皖', '浙', '闽', '贛', '湘', '鄂', '粤', '琼', '甘', '陕', '贵', '云', '川'
  ];

  @override
  void initState() {
    super.initState();
  // _getLocalCarPlate();
  }

  
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      child:  Container(
      width: 46.0,
      height: 34.0,
      padding: EdgeInsets.only(left: 6.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: Colors.blue
      ),
      child: Row(
        children: <Widget>[
          Text(widget._selectedValue, style: TextStyle(fontSize: 16.0, color: Colors.white),),
          Icon(Icons.arrow_drop_down, color: Colors.white,)
        ],
      )
    ),
      onTap: () {
       showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey
                ),
                width: MediaQuery.of(context).size.width,
                height: 300.0,
                child: GridView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setString('car_plate', _carPlate[index]);
                            // setState(() {
                            //   _selectedValue = _carPlate[index];
                            // });
                            widget.valueChanged(_carPlate[index]);
                            Navigator.of(context).pop();
                          });
                      },
                      child: Container(
                      width: 36.0,
                      height: 36.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _carPlate[index] == widget._selectedValue ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      child: Text('${_carPlate[index]}', style: TextStyle(color: Colors.black),),
                    ),
                    )
                    ;
                  },
                              itemCount: 31,
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 50,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0
                              ),
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              
                            ),
              );
            }
          );
      },
    );
  }
}