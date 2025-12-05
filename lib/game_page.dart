
import 'dart:math';
import 'package:flutter/material.dart';
import 'scratch_cell.dart';

enum BonusIcon { necklace, watch, crown, ring, anklet, earring, money }

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override State<GamePage> createState()=>_GamePageState();
}

class _GamePageState extends State<GamePage>{
  final rnd=Random();
  int balance=0;
  int noWin=0;
  bool cardFinished=false;
  int cardId=0;

  List<int> grid=List.filled(9,0);
  List<int> bonus=List.filled(3,0);
  List<BonusIcon> bonusIcons=List.filled(3,BonusIcon.necklace);
  List<bool> rMain=List.filled(9,false);
  List<bool> rBonus=List.filled(3,false);
  Set<int> winningCells={};

  final pool=[1,5,10,20,50,100,200,300,500,1000,2000,5000,10000,20000,50000,100000,1000000,10000000];

  @override void initState(){super.initState(); newCard(true);}

  bool isCardFinished()=> rMain.every((e)=>e) && rBonus.every((e)=>e);

  void newCard(bool first){
    if(!first && !cardFinished) return;
    cardFinished=false; winningCells.clear(); cardId++;
    if(!first){ balance-=100; if(balance<=-2000){setState((){}); return;} }
    rMain=List.filled(9,false); rBonus=List.filled(3,false);

    if(noWin>=3){
      var small=[1,5,10,20,50,100,200,300,500];
      int s=small[rnd.nextInt(small.length)];
      grid=[s,s,s];
      while(grid.length<9){
        int x=pool[rnd.nextInt(pool.length)];
        if(grid.where((e)=>e==x).length<3) grid.add(x);
      }
      noWin=0;
    } else {
      grid=[]; Map<int,int> c={};
      while(grid.length<9){
        int x=pool[rnd.nextInt(pool.length)];
        if(x>20000 && (c[x]??0)>=2) continue;
        if((c[x]??0)>=3) continue;
        grid.add(x); c[x]=(c[x]??0)+1;
      }
    }

    var small2=pool.where((e)=>e<1000).toList();
    bonus=List.generate(3,(_)=>small2[rnd.nextInt(small2.length)]);
    bonusIcons=List.generate(3,(_)=>BonusIcon.values[rnd.nextInt(BonusIcon.values.length)]);
    setState((){});
  }

  void reveal(){
    if(isCardFinished()){
      int win=calc();
      if(win>0) noWin=0; else noWin++;
      balance+=win; cardFinished=true; setState((){});
    }
  }

  int calc(){
    int win=0; winningCells.clear(); var c=<int,int>{};
    for(int i=0;i<9;i++){int v=grid[i]; c[v]=(c[v]??0)+1;}
    c.forEach((k,v){
      if(v>=3){
        int count=0;
        for(int i=0;i<9;i++){
          if(grid[i]==k){
            winningCells.add(i); count++;
            if(count==v) break;
          }
        }
        win+=k;
      }
    });
    for(int i=0;i<3;i++) if(bonusIcons[i]==BonusIcon.money) win+=bonus[i];
    return win;
  }

  IconData icon(BonusIcon b){
    switch(b){
      case BonusIcon.necklace: return Icons.checkroom;
      case BonusIcon.watch: return Icons.watch;
      case BonusIcon.crown: return Icons.workspace_premium;
      case BonusIcon.ring: return Icons.diamond;
      case BonusIcon.anklet: return Icons.all_inclusive;
      case BonusIcon.earring: return Icons.earbuds;
      case BonusIcon.money: return Icons.attach_money;
    }
  }

  @override Widget build(BuildContext context){
    if(balance<=-2000){
      return Scaffold(backgroundColor:Colors.black, body:Center(
        child:Text("BATTIN! Bakiye: $balance ₺", style:TextStyle(color:Colors.red,fontSize:32)),
      ));
    }

    return Scaffold(
      backgroundColor:Colors.green.shade900,
      body:Row(children:[
        Expanded(
          flex:4,
          child:Center(
            child:AspectRatio(
              aspectRatio:1,
              child:GridView.builder(
                physics:NeverScrollableScrollPhysics(),
                padding:EdgeInsets.all(8),
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:3, mainAxisSpacing:8, crossAxisSpacing:8),
                itemCount:9,
                itemBuilder:(c,i)=>ScratchCell(
                  scratchKeyId:"m_${cardId}_$i",
                  highlight: winningCells.contains(i) && cardFinished,
                  onReveal:(){ rMain[i]=true; reveal(); },
                  child:Text("${grid[i]} ₺", style:TextStyle(color:Colors.white,fontSize:22)),
                ),
              ),
            ),
          ),
        ),

        VerticalDivider(thickness:2,color:Colors.white24),

        Expanded(
          flex:2,
          child:Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: List.generate(3,(i)=>
              Padding(
                padding:EdgeInsets.all(8),
                child:ScratchCell(
                  scratchKeyId:"b_${cardId}_$i",
                  highlight:false,
                  onReveal:(){ rBonus[i]=true; reveal(); },
                  child:Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children:[
                      Icon(icon(bonusIcons[i]), color:Colors.white, size:28),
                      SizedBox(height:6),
                      Text("${bonus[i]} ₺", style:TextStyle(color:Colors.white,fontSize:20)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        VerticalDivider(thickness:2,color:Colors.white24),

        Expanded(
          flex:3,
          child:Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children:[
              Text("Kasa: $balance ₺", style:TextStyle(color:Colors.white,fontSize:30)),
              SizedBox(height:20),
              ElevatedButton(
                onPressed: cardFinished? ()=>newCard(false): null,
                child:Text("Yeni Kart (-100 ₺)"),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
