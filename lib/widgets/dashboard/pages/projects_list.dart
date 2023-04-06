import 'package:flutter/material.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/projects.dart';
import 'package:mil/widgets/details/NavigationDetails.dart';
import 'package:mil/widgets/details/project_details.dart';

class ProjectsList extends StatelessWidget {
  final List<Projects> projects;
  const ProjectsList({Key? key, required this.projects}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Material(
        child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: projects.length,
      padding: EdgeInsets.all(12.0),
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemBuilder: (BuildContext ctxt, int index) {
        return Container(
            decoration: BoxDecoration(
              border: index == 0
                  ? const Border() // This will create no border for the first item
                  : Border(
                      top: BorderSide(
                          width: 1,
                          color: Colors
                              .black26)), // This will create top borders for the rest
            ),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProjectDetails(
                                projects[index].lINK.toString(),
                                projects[index].tITLE.toString(),
                                projects[index].avlCount.toString(),
                                projects[index].alloCount.toString(),
                                projects[index].mortCount.toString(),
                                projects[index].regsCount.toString(),
                                projects[index].reseCount.toString(),
                                projects[index].totcount.toString(),
                              )));
                },
                child: Container(
                  child: Column(
                    children: [
                      Card(
                          elevation: 5,
                          margin: EdgeInsets.all(10.0),
                          child: Container(
                            height: 150,
                            width: 250,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    ApiConfig.LOAD_IMAGES_BASE_URL +
                                        projects[index].iMAGE.toString()),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            margin: EdgeInsets.all(0),
                            child: Text(
                                projects[index]
                                    .tITLE
                                    .toString()
                                    .trim()
                                    .toUpperCase(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline2)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                  'Total: ' +
                                      projects[index]
                                          .totcount
                                          .toString()
                                          .trim(),
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.bodyText1),
                              Spacer(),
                              Spacer(),
                              Text(
                                  'Available: ' +
                                      projects[index]
                                          .avlCount
                                          .toString()
                                          .trim(),
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                projects[index].longitude.toString() != 'null'
                                    ? ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NavigationDetails(
                                                          projects[index]
                                                              .tITLE
                                                              .toString(),
                                                          projects[index]
                                                              .longitude
                                                              .toString(),
                                                          projects[index]
                                                              .latitude
                                                              .toString())));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green[400],
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                // borderRadius: BorderRadius.circular(5.0),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15.0))
                                                // side: BorderSide(
                                                //     color: Theme.of(context).primaryColor
                                                // )
                                                )),
                                        child: Text("Navigation",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    : Container(),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProjectDetails(
                                                    projects[index]
                                                        .lINK
                                                        .toString(),
                                                    projects[index]
                                                        .tITLE
                                                        .toString(),
                                                    projects[index]
                                                        .avlCount
                                                        .toString(),
                                                    projects[index]
                                                        .alloCount
                                                        .toString(),
                                                    projects[index]
                                                        .mortCount
                                                        .toString(),
                                                    projects[index]
                                                        .regsCount
                                                        .toString(),
                                                    projects[index]
                                                        .reseCount
                                                        .toString(),
                                                    projects[index]
                                                        .totcount
                                                        .toString())));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      elevation: 10,
                                      backgroundColor: Colors.green[400],
                                      shape: RoundedRectangleBorder(
                                          // borderRadius: BorderRadius.circular(5.0),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.0))
                                          // side: BorderSide(
                                          //     color: Theme.of(context).primaryColor
                                          // )
                                          )),
                                  child: Text("Availability",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ))); /*Card(
                margin: EdgeInsets.all(8.0),
                child: );*/
      },
    ));
  }
}
