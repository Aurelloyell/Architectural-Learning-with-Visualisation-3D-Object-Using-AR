import 'package:arsitektur_app/screens/explanation_page.dart';
import 'package:flutter/material.dart';

// A simple data model for our educational content.
class Materi {
  final String title;
  final String content;
  final IconData icon;

  const Materi({required this.title, required this.content, required this.icon});
}

// A list of all available materials. You can easily add more here.
final List<Materi> materiList = [
  const Materi(
    title: 'Prinsip Dasar Arsitektur',
    icon: Icons.foundation,
    content: 'Prinsip dasar arsitektur mencakup tiga elemen utama yang dikemukakan oleh Vitruvius: Firmitas (Kekuatan), Utilitas (Fungsi), dan Venustas (Keindahan). Firmitas berarti bangunan harus kokoh dan tahan lama. Utilitas berarti bangunan harus berfungsi sesuai dengan tujuannya. Venustas berarti bangunan harus memiliki nilai estetika atau keindahan yang memanjakan mata. Keseimbangan dari ketiga prinsip ini menghasilkan karya arsitektur yang berhasil dan abadi.',
  ),
  const Materi(
    title: 'Arsitektur Gotik',
    icon: Icons.church,
    content: 'Arsitektur Gotik adalah gaya arsitektur yang berkembang di Eropa selama Abad Pertengahan. Ciri khas utamanya adalah penggunaan lengkungan runcing (pointed arch), vault berusuk (ribbed vault), dan penopang layang (flying buttress). Inovasi-inovasi ini memungkinkan pembangunan katedral-katedral yang sangat tinggi dengan dinding yang lebih tipis dan jendela-jendela kaca patri yang besar, menciptakan interior yang terang dan megah yang melambangkan surga di bumi.',
  ),
  const Materi(
    title: 'Arsitektur Modern',
    icon: Icons.business,
    content: 'Arsitektur Modern muncul pada awal abad ke-20 sebagai respons terhadap perubahan industri dan sosial. Gaya ini menolak ornamenasi dan merangkul minimalisme, dengan semboyan "form follows function" (bentuk mengikuti fungsi). Material seperti baja, beton, dan kaca digunakan secara ekstensif. Arsitek terkenal seperti Le Corbusier, Ludwig Mies van der Rohe, dan Frank Lloyd Wright adalah pionir dari gerakan ini, menciptakan bangunan dengan garis-garis bersih dan ruang terbuka.',
  ),
   const Materi(
    title: 'Bahan Bangunan Berkelanjutan',
    icon: Icons.eco,
    content: 'Arsitektur berkelanjutan, atau arsitektur hijau, adalah pendekatan desain yang bertujuan untuk meminimalkan dampak negatif bangunan terhadap lingkungan. Ini melibatkan penggunaan bahan bangunan yang ramah lingkungan seperti bambu, kayu daur ulang, dan beton ramah lingkungan. Selain itu, desain juga berfokus pada efisiensi energi melalui pencahayaan alami, ventilasi silang, panel surya, dan sistem pengumpul air hujan untuk menciptakan bangunan yang sehat bagi penghuninya dan planet ini.',
  ),
];


class MateriPage extends StatelessWidget {
  const MateriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materi'),
        // The back button will be automatically added by Flutter's Navigator
        // when this page is pushed from the HomePage.
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: materiList.length,
        itemBuilder: (context, index) {
          final materi = materiList[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Icon(materi.icon, size: 32, color: Theme.of(context).colorScheme.primary),
              title: Text(
                materi.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                // Navigate to the new ExplanationPage, passing the data.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExplanationPage(
                      title: materi.title,
                      content: materi.content,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
