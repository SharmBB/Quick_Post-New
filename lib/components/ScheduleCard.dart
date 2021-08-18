import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardDate(),
            CardRow(),
          ],
        );
      }
    );
  }
}

class CardDate extends StatelessWidget {
  final String? date;
  const CardDate({
    Key? key, 
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
      child: Text(date!,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500
      ),
      ),
    );
  }
}

class CardRow extends StatelessWidget {
  final String? src;
  final String? content;
  final String? time;
  final VoidCallback? press;
  const CardRow({
    Key? key, 
    this.src, 
    this.content,
    this.time, 
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 90,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(time!),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: InkWell(
              onTap: press,
              child: Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x20000000),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(                      
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                            ),
                            // child: Image.network(
                            //     src, 
                            //     width: 80,
                            //     height: 80,
                            //     fit:BoxFit.cover

                            // ),
                            child: FadeInImage.assetNetwork(
                                    placeholderScale: 15.0,
                                    imageScale: 8.0,
                                    width: 80,
                                    height: 80,
                                    fit:BoxFit.cover,
                                      placeholder: 'assets/logo_thumbnail.jpg',
                                      image: src!,
                                )
                          ),
                          Expanded(
                            child: Container(   
                              width: MediaQuery.of(context).size.width*0.5,                             
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 3),
                                    child: Text(content!,
                                    style: TextStyle(fontSize: 11),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],                        
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}