// import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class PresentationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PresentationScreen(),
    );
  }
}

class PresentationScreen extends StatelessWidget {
  void launchPhoneCall(String phoneNumber) async {
    final phoneUrl = 'tel:$phoneNumber';

    if (await canLaunchUrl(phoneUrl as Uri)) {
      await launchUrl(phoneUrl as Uri);
    } else {
      // Gestion des erreurs si l'appel ne peut pas être lancé
      throw 'Impossible de lancer l\'appel : $phoneUrl';
    }
  }

  _makingPhoneCall() async {
    var url = Uri.parse("tel:+22960559894");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildExpansionTile(String title, String content) {
    return Card(
      child: ExpansionTile(
        title: Text(title),
        children: <Widget>[
          ListTile(
            title: SmallText(
              color: Colors.black54,
              text: content,
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour naviguer vers la page correspondante
  void navigateToPage(BuildContext context, String pageName) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SectionPage(sectionName: pageName),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              LineAwesomeIcons.angle_left,
              color: Colors.orange,
            )),
        titleTextStyle: TextStyle(
            color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold),
        // backgroundColor: Color.fromRGBO(10, 80, 137, 0.8),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/images/Icone.png'),
            Padding(
              padding: EdgeInsets.all(Dimensions.height15),
              child: Text(
                'A propos de Allô Group',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // ========================= Mouba review =========================
            buildExpansionTile('Qui sommes nous ?',
                "Allô Group est la solution à vos besoins.Elle est une application de référence en Afrique où chaque utilisateur a une valeur ajouté. Elle vous permet de vous déplacez en commandant des zémidjans et des taxis où que vous soyez et ce depuis votre téléphone, de faire vos courses auprès des boutiques en ligne qui vous proposent un large catalogue de produits tels que la restauration, l’épicerie, l’électroménager, etc…,de faire des propositions vos produits à votre cible clientèle."),

            buildExpansionTile('Pourquoi choisir AllôGroup ?',
                "Allô Group vous propose ses services à des coûts défiants toutes concurrences. Avec Allô Group, restez chez vous et trouvez un zem et taxi en toute assurance. Inutile de négocier ni les frais de transport, ni les frais de course et perdre votre temps puisqu’il vous convient déjà. Vous êtes en toute sécurité et assuré lors de votre transport et vous suivez le parcours de vos courses en temps réel."),

            buildExpansionTile('Comment réserver sa course ?',
                "Pour réserver la course Allô Group, c’est très simple ! Une fois rentrer dans l’application Allô Group, choisissez le service de Allô Livreur puis suivre les étapes suivantes: Créer un ticket de course-Saisir l'adresse de récupération du colis-Saisir l'adresse de destination du colis-Choisir une date ultérieur pour la course-Appuyer sur « confirmer la destination ». En l’espace de quelques minutes, votre coursier vous contactera pour confirmation à son niveau."),

            buildExpansionTile('Quels moyens de paiements acceptez-vous  ?',
                "Avec le service Allô Food de Allô Group, vous pouvez choisir votre paiement parmi : Espèces, Portefeuille Allô Group, Carte Bancaire, MTN-Momo, Flozz. Toutes les informations personnelles de nos clients sont confidentielles et bien sécurisées. Allô Group est en partenariat avec des professionnels de renommée internationale dans le domaine pour assurer cette confidentialité et cette sécurité."),

            buildExpansionTile('Comment parrainer un nouvel utilisateur ?',
                "Pour parrainer un nouvel utilisateur, prière entrer dans l’application et suivre les différentes étapes suivantes: Entrez dans le Menu de l’application situé au niveau des paramètres.  Appuyez sur le boutton de parrainage pour générer un code . Partagez votre code de parrainage à votre ami qui vient juste de créer son compte Allô Group. Mais attention !!! La limite du parrainage est fixée à 15 personnes, passé ce nombre, votre code devient obsolète. Bénéficier un code promo généré en parrainant un(e) ami(e) qui effectue une course avec l’application Allô Group dans un délai de 30 jours."),

            // buildExpansionTile('Comment me faire livrer ?',
            //     "Text"),

            buildExpansionTile(
                'Comment faire livrer à une adresse autre que la mienne ?',
                "Après la commande, il faut juste choisir l’adresse de livraison souhaitée dans l’interface qui s’affiche."),

            buildExpansionTile('Que faire en cas de perte de colis ?',
                "Ecrivez au service client via le numéro +22953899427 ou via la partie Aide de l’application en précisant le numéro de commande puis en envoyant des photos de la commande erronée. Le service client se changera de rentrer en contact avec les parties prennantes  afin de déterminer les responsabilités et reviendra vers vous avec un apport de solution. Vous pouvez toutefois nous contacter sur nos différents numéros du service client."),

            buildExpansionTile(
                'Que faire si je reçois un colis/repas autre que le mien ?',
                "Ecrivez au service client via le numéro +22953899427 ou via la partie Aide de l’application en précisant le numéro de commande puis en envoyant des photos de la commande erronée. Le service client se changera de rentrer en contact avec les parties prennantes (restaurant/boutique et livreur) afin de déterminer les responsabilités et reviendra vers vous avec un apport de solution. Vous pouvez toutefois nous contacter sur nos différents numéros du service client."),

            buildExpansionTile(
              'Que faire si mon colis/repas m\'est livré tout endommagé ?',
              "Ecrivez au service client via le numéro +22953899427 ou via la partie Aide de l’application en précisant le numéro de commande puis en envoyant des photos de la commande erronée. Le service client se changera de rentrer en contact avec les parties prennantes (restaurant/boutique et livreur) afin de déterminer les responsabilités et reviendra vers vous avec un apport de solution. Vous pouvez toutefois nous contacter sur nos différents numéros du service client.",
            ),

            buildExpansionTile(
                'Que faire si je ne reçois pas le repas commandé à temps ?',
                "Ecrivez au service client via le numéro +22953899427 ou via la partie Aide de l’application en précisant le numéro de commande puis en envoyant des photos de la commande erronée. Le service client se changera de rentrer en contact avec les parties prennantes (restaurant/boutique et livreur) afin de déterminer les responsabilités et reviendra vers vous avec un apport de solution. Vous pouvez toutefois nous contacter sur nos différents numéros du service client."),

            buildExpansionTile('Comment télécharger l\'application AllôGroup ?',
                "Allez sur le play store de votre android et recherchez AllôGroup."),

            buildExpansionTile('Qui contacter en cas de problème particulier ?',
                "Contactez notre service client via le numéro +22953899427"),
            // ========================= endMouba review =========================
          ],
        ),
      ),
      // Ajoutez un bouton flottant pour passer un appel téléphonique
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _makingPhoneCall();
          // launchPhoneCall('tel:0022960559894');
          // launchPhoneCall(0022960559894 as String);
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.phone), // Couleur du bouton
      ),
    );
  }
}

class SectionPage extends StatelessWidget {
  final String sectionName;

  SectionPage({required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sectionName),
      ),
      body: Center(
        child: Text('Contenu de la section "$sectionName"'),
      ),
    );
  }
}
