import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bmi_list extends StatefulWidget {
  @override
  _BMIListState createState() => _BMIListState();
}

class _BMIListState extends State<bmi_list> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your BMI History'),
      ),
      body: _buildBMIList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document['bmi'].toString()),
      subtitle: Text(document['date']),
    );
  }

  Widget _buildBMIList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('BMI_LIST')
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.white,
            );
          },
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, snapshot.data.documents[index]),
        );
      },
    );
  }
}
