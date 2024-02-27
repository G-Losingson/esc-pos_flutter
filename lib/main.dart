import 'package:flutter/material.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrinterApp Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PrinterApp Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic result;

  Future testTicket() async {
    // // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    bytes += generator.text(
      'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ',
    );

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    bytes +=
        generator.text('Reverse text', styles: const PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.text('Text size 200%',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    bytes += generator.feed(2);
    bytes += generator.cut();

    result = bytes;
    // generator.row([
    //   PosColumn(
    //     text: 'col3',
    //     width: 3,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //   PosColumn(
    //     text: 'col6',
    //     width: 6,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //   PosColumn(
    //     text: 'col3',
    //     width: 3,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    // ]);

    // final ByteData data = await rootBundle.load('images/logo.jpeg');
    // final Uint8List bytes = data.buffer.asUint8List();
    // dynamic image = decodeImage(bytes);

    /// Using `ESC *`
    //generator.image(image);

    /// Using `GS ( L`
    //generator.imageRaster(image, imageFn: PosImageFn.graphics);

    //final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    //generator.barcode(Barcode.upcA(barData));

    //generator.qrcode('Georges Byona');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    dynamic profilImg =
        "https://media.licdn.com/dms/image/D4D03AQGbzh9Jnqnqag/profile-displayphoto-shrink_100_100/0/1695199699034?e=1714608000&v=beta&t=f1K9DFKLNsfa4QgtexfK9NwXg_TctD2DpIKi7zbX1wg";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        titleTextStyle: TextStyle(
          color: Colors.blue.shade600,
          letterSpacing: 1,
          fontSize: 25,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            alignment: Alignment.center,
            height: 50,
            width: 50,
            child: CachedNetworkImage(
              alignment: Alignment.center,
              imageUrl: profilImg,
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueGrey.shade200,
                    image: DecorationImage(
                      image: imageProvider,
                    ),
                  ),
                );
              },
              progressIndicatorBuilder: (context, url, downloadProgress) {
                return SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    strokeWidth: 2,
                  ),
                );
              },
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size(double.infinity, 20),
          child: Icon(null),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Here the result of your printing :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 20,
                height: 5,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    result == null ? 'No result' : '$result',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign:
                        result == null ? TextAlign.center : TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: result == null
          ? FloatingActionButton(
              onPressed: testTicket,
              child: const Icon(
                Icons.print,
                color: Colors.blue,
              ),
            )
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  result = null;
                });
              },
              child: const Icon(
                Icons.close_sharp,
                color: Colors.blue,
              ),
            ),
    );
  }
}
