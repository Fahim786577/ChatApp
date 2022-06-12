//import 'dart:html';

import 'dart:ui';

import 'package:chatapp/app.dart';
import 'package:chatapp/helpers.dart';
import 'package:chatapp/screens/chatscreen.dart';
import 'package:chatapp/theme.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/models/models.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:chatapp/widgets/realavatar.dart' as realavatar;

class Messages extends StatefulWidget {
  const Messages({ Key? key }) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  

  Widget build(BuildContext context) {
    final channelListController = ChannelListController();
    return ChannelListCore(
      channelListController: channelListController,
      filter: Filter.and(
        [
          Filter.equal('type', 'messaging'),
          Filter.in_('members', [
            StreamChatCore.of(context).currentUser!.id,
          ])
        ],
      ),
      errorBuilder: (context,error) => DisplayErrorMessage(
        error: error,
      ), 

      emptyBuilder: (context) => const Center(
        child: Text(
          'So empty.\nGo and message someone.',
          textAlign: TextAlign.center,
        ),
      ),

      loadingBuilder: (
        context,
      ) =>
          const Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(),
        ),
      ),

      listBuilder: (context,channels){
        return CustomScrollView(
            slivers: [
            const SliverToBoxAdapter(
                child: _Stories(),
            ),
            SliverList(delegate: SliverChildBuilderDelegate(
                (context, index){
                  return _MessageTile(channel: channels[index]);
                },
                childCount: channels.length
            )),
          ],
        );
      }
    ); 
    
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({Key? key,  required this.channel}) : super(key: key);
  final Channel channel;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(ChatScreen.routeWithChannel(channel));
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
                  child: realavatar.Avatar.medium(url: Helpers.getChannelImage(channel, context.currentUser!)),
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
                            Helpers.getChannelName(channel, context.currentUser!),
                            style: const TextStyle(fontWeight: FontWeight.w900,letterSpacing: 0.2,wordSpacing: 1.5,fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height:20,
                          child:_lastmessage()
                        )
          
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
                            _lastmessagedate(),
                        const SizedBox(height: 8),
                        Center(
                          child:UnreadIndicator(
                            channel:channel
                          )
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

  //Last Message method
  Widget _lastmessage() {
    return BetterStreamBuilder<int>(
      stream: channel.state!.unreadCountStream,
      initialData: channel.state?.unreadCount ?? 0,
      builder: (context, count) {
        return BetterStreamBuilder<Message>(
          stream: channel.state!.lastMessageStream,
          initialData: channel.state!.lastMessage,
          builder: (context, lastMessage) {
            return Text(
              lastMessage.text ?? '',
              overflow: TextOverflow.ellipsis,
              style: (count > 0)
                  ? const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w900
                    )
                  : const TextStyle(
                      fontSize: 12,
                      color: AppColors.textFaded,
                    ),
            );
          },
        );
      },
    );
  }// End lastmessage method

  // last message date method

   Widget _lastmessagedate() {
    return BetterStreamBuilder<DateTime>(
      stream: channel.lastMessageAtStream,
      initialData: channel.lastMessageAt,
      builder: (context, data) {
        final lastMessageAt = data.toLocal();
        String stringDate;
        final now = DateTime.now();

        final startOfDay = DateTime(now.year, now.month, now.day);

        if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay.millisecondsSinceEpoch) {
          stringDate = Jiffy(lastMessageAt.toLocal()).jm;
        } else if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay
                .subtract(const Duration(days: 1))
                .millisecondsSinceEpoch) {
          stringDate = 'YESTERDAY';
        } else if (startOfDay.difference(lastMessageAt).inDays < 7) {
          stringDate = Jiffy(lastMessageAt.toLocal()).EEEE;
        } else {
          stringDate = Jiffy(lastMessageAt.toLocal()).yMd;
        }
        return Text(
          stringDate,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: -0.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textFaded,
          ),
        );
      },
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
          realavatar.Avatar(radius: 25,url: storyData.url),
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