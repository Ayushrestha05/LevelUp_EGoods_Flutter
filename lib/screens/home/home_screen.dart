import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/size_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://icons-for-free.com/iconfiles/png/512/buy+ecommerce+logo+price+sale+shop+shopping+icon-1320183862496435117.png'))),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'LevelUp E-Goods',
                    style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications_outlined),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: const Text(
                      'Upcoming Items',
                      style: TextStyle(fontFamily: 'Outfit', fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      color: Theme.of(context).primaryColor.value == 4280361249
                          ? Colors.white
                          : Colors.black,
                      height: 2,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          3.0, // Move to right 10  horizontally
                          4.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://media.vandal.net/i/1200x630/74234/elden-ring-20216102202120_1.jpg')),
                    color: Colors.grey),
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 0,
                          child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: const Text(
                                'Upcoming Feb 22, 2022',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Outfit',
                                    fontSize: 18),
                              )))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: const Text(
                      'Artist Specials',
                      style: TextStyle(fontFamily: 'Outfit', fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      color: Theme.of(context).primaryColor.value == 4280361249
                          ? Colors.white
                          : Colors.black,
                      height: 2,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          3.0, // Move to right 10  horizontally
                          4.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ]),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 7),
                      height: 170,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://media.discordapp.net/attachments/905466870625341490/905469510918754364/varguy-2.png?width=669&height=669')),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Spacer(),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueAccent,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          'https://media.discordapp.net/attachments/678569644667174926/942349553506603028/melonseeds.png')),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'melonseeds',
                                  style: TextStyle(
                                      fontFamily: 'Outfit', fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: const Text(
                      'Sales',
                      style: TextStyle(fontFamily: 'Outfit', fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      color: Theme.of(context).primaryColor.value == 4280361249
                          ? Colors.white
                          : Colors.black,
                      height: 2,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(rWidth(10)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          3.0, // Move to right 10  horizontally
                          4.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ]),
                child: InkWell(
                  onTap: () {},
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'https://www.allkeyshop.com/blog/wp-content/uploads/red-dead-redemption-2-banner3.jpg')),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              decoration: BoxDecoration(
                                  color: Color(0xFF21AA47),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                '-30%',
                                style: TextStyle(
                                    fontFamily: 'Righteous',
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'NPR 4500',
                                  style: TextStyle(
                                      fontFamily: 'Righteous',
                                      color: Colors.white,
                                      fontSize: 18,
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2.85),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'NPR 3014',
                                      style: TextStyle(
                                          fontFamily: 'Righteous',
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
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
