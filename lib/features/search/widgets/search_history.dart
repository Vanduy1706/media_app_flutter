import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchHistory extends StatelessWidget {
  final String inputSearch;
  const SearchHistory({super.key, required this.inputSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom : 10, left: 10),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: SvgPicture.asset('assets/icons/ic_round-history.svg', width: 24, height: 24,
            colorFilter: ColorFilter.mode(Color.fromRGBO(147, 146, 149, 1), BlendMode.srcIn),),
          ),
          Text(inputSearch, style: TextStyle(color: Color.fromRGBO(147, 146, 149, 1), fontWeight: FontWeight.bold, fontSize: 16),)
        ],
      ),
    );
  }
}