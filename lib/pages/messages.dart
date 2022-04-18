//import 'dart:html';

import 'dart:ui';

import 'package:chatapp/helpers.dart';
import 'package:chatapp/screens/chatscreen.dart';
import 'package:chatapp/theme.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/models/models.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:jiffy/jiffy.dart';
class Messages extends StatelessWidget {
  const Messages({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
            child: _Stories(),
        ),
        SliverList(delegate: SliverChildBuilderDelegate(
            _delegate
        )),
      ],
    );

  }
  Widget _delegate (BuildContext context, int index){
    final faker = Faker();
    final date = Helpers.randomDate();
    return _MessageTile(messageData: MessageData(
      senderName: faker.person.name(),
      senderMessage: faker.lorem.sentence(),
      messageDate:date,
      dateMessage: Jiffy(date).fromNow(),
      profilePic: Helpers.randomPictureUrl()


    ));
  }
}
class _MessageTile extends StatelessWidget {
  const _MessageTile({Key? key,  required this.messageData}) : super(key: key);
  final MessageData messageData;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(ChatScreen.route(messageData));
      },
      child: Container(
        height: 100,
         margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.2,
              ),
            ),
          ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Avatar.medium(url: messageData.profilePic),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            messageData.senderName,
                            style: const TextStyle(fontWeight: FontWeight.w900,letterSpacing: 0.2,wordSpacing: 1.5,fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height:20,
                          child:Text(
                            messageData.senderMessage,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12,color:AppColors.textFaded),
                            ),)
          
                      ],
                    ),
                  ),
                ),
                
                //MESSAGE RECIEVED DATE
          
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                       const SizedBox(height: 4),
                            Text(
                                messageData.dateMessage.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  letterSpacing: -0.2,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textFaded,
                                ),
                              ),
                        const SizedBox(height: 8),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                                    '1',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                          ),
                        )  
                    ],
                  ),
                ),
                
                //*****MESSAGE RECIEVED DATE END
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stories extends StatelessWidget {
  const _Stories({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: SizedBox(
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0),
                child: Text('Stories',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900,color: AppColors.textFaded),),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index){
                    final faker = Faker();
                  return _StoryCard(storyData: StoryData(name: faker.person.firstName(),url: Helpers.randomPictureUrl()));
                }),
              )
            ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    Key? key,
    required this.storyData,
  }) : super(key: key);

 final StoryData storyData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Avatar(radius: 25,url: storyData.url),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                storyData.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}