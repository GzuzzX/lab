import 'dart:math'; // นำเข้าเครื่องมือคณิตศาสตร์ ในโค้ดนี้ใช้ Random เพื่อสุ่มคะแนน
import 'package:flutter/material.dart'; // นำเข้าเครื่องมือสร้างหน้าจอ Flutter แบบ Material

class LabTest extends StatefulWidget { // สร้างหน้าจอชื่อ LabTest ที่มีข้อมูลเปลี่ยนแปลงได้
  const LabTest({super.key}); // constructor สำหรับสร้างหน้าจอ และส่ง key ให้คลาสแม่

  @override // ระบุว่าเขียนเมธอดแทนเมธอดที่คลาสแม่กำหนดไว้
  State<LabTest> createState() => _LabTestState(); // สร้างตัวจัดการสถานะของหน้าจอนี้
} // จบคลาส LabTest

class _LabTestState extends State<LabTest> { // สร้างคลาสเก็บข้อมูลและการทำงานของ LabTest; _ ทำให้เป็น private ภายในไลบรารี
  final String img1 = 'assets/images/steak.png'; // เก็บตำแหน่งรูปสเต๊ก ใช้ final เพราะจะไม่กำหนดค่าใหม่
  final String img2 = 'assets/images/lobster.png'; // เก็บตำแหน่งรูปล็อบสเตอร์
  final String img3 = 'assets/images/cake.png'; // เก็บตำแหน่งรูปเค้ก

  TextEditingController c1 = TextEditingController(); // สร้างตัวควบคุมสำหรับอ่านและแก้ไขข้อความในช่องคะแนนแรก
  TextEditingController c2 = TextEditingController(); // สร้างตัวควบคุมช่องคะแนนที่สอง
  TextEditingController c3 = TextEditingController(); // สร้างตัวควบคุมช่องคะแนนที่สาม

  int r1 = 0; // เก็บคะแนนอาหารรายการแรก เริ่มต้นเป็น 0
  int r2 = 0; // เก็บคะแนนอาหารรายการที่สอง เริ่มต้นเป็น 0
  int r3 = 0; // เก็บคะแนนอาหารรายการที่สาม เริ่มต้นเป็น 0
  int avgStar = 0; // เก็บจำนวนดาวของคะแนนเฉลี่ย เริ่มต้นเป็น 0
  String msg = ''; // เก็บข้อความที่จะแสดง เริ่มต้นเป็นข้อความว่าง

  Widget starRow(int n) { // สร้างฟังก์ชันที่รับจำนวนดาวสีเหลือง n และคืนค่าเป็น Widget
    return Row( // คืนแถวที่จัดดาวเรียงในแนวนอน
      mainAxisAlignment: MainAxisAlignment.center, // จัดกลุ่มดาวไว้กึ่งกลางแถว
      children: List.generate( // สร้างรายการ Widget สำหรับใส่ในแถว
        5, // กำหนดให้สร้างทั้งหมด 5 รายการ
        (i) => Icon( // แต่ละรายการเป็นไอคอน โดย i คือลำดับตั้งแต่ 0 ถึง 4
          Icons.star, // เลือกไอคอนรูปดาว
          color: i < n ? Colors.amber : const Color.fromARGB(255, 0, 0, 0), //า  ถ้า i น้อยกว่n ใช้สีเหลือง มิฉะนั้นใช้สีดำ
          size: 22, // กำหนดขนาดไอคอนดาวเป็น 22 หน่วย
        ), // จบการสร้างไอคอนหนึ่งดวง
      ), // จบ List.generate
    ); // จบ Row และคืนค่าออกจากฟังก์ชัน
  } // จบฟังก์ชัน starRow

  Widget foodCard(String image, TextEditingController controller, int rating) { // รับรูป ตัวควบคุมช่องกรอก และคะแนน เพื่อสร้างการ์ดอาหาร
    return Expanded( // ให้การ์ดขยายแบ่งพื้นที่ที่เหลือใน Row; ทั้งสามใบมีสัดส่วนเท่ากัน
      child: Container( // สร้างกล่องสำหรับกำหนดสีและพื้นที่ภายในการ์ด
        color: const Color(0xFF29B6F6), // กำหนดพื้นหลังของการ์ดเป็นสีฟ้า
        padding: const EdgeInsets.all(8.0), // เว้นพื้นที่ด้านในทุกด้าน 8 หน่วย
        child: Column( // จัดเนื้อหาในการ์ดจากบนลงล่าง
          children: [ // เริ่มรายการ Widget ภายในการ์ด
            Image.asset( // แสดงรูปจากไฟล์ asset ของแอป
              image, // ใช้ตำแหน่งรูปที่ส่งเข้ามาในฟังก์ชัน
              height: 110, // กำหนดความสูงของพื้นที่รูปเป็น 110 หน่วย
              fit: BoxFit.contain, // ปรับรูปให้พอดีกับพื้นที่โดยคงสัดส่วนและไม่ตัดรูป
              errorBuilder: (context, error, stack) { // กำหนดสิ่งที่จะแสดงแทน หากโหลดรูปเกิดข้อผิดพลาด
                return const SizedBox( // คืนกล่องสำหรับแสดงไอคอนแทนรูป
                  height: 110, // ให้กล่องแทนรูปมีความสูง 110 หน่วย
                  child: Icon(Icons.fastfood), // แสดงไอคอนอาหารแทนรูปที่โหลดไม่ได้
                ); // จบ SizedBox ที่ใช้แทนรูป
              }, // จบฟังก์ชัน errorBuilder
            ), // จบ Image.asset
            TextField( // สร้างช่องกรอกคะแนน
              controller: controller, // เชื่อมช่องกรอกกับตัวควบคุมที่ส่งเข้ามา
              textAlign: TextAlign.center, // จัดข้อความในช่องให้อยู่กึ่งกลาง
              keyboardType: TextInputType.number, // ขอแป้นพิมพ์ตัวเลข แต่ยังต้องตรวจความถูกต้องของข้อมูลเอง
              decoration: const InputDecoration( // กำหนดรูปแบบและข้อความแนะนำของช่องกรอก
                hintText: '1-5', // แสดงข้อความ 1-5 เมื่อช่องกรอกยังว่าง
                hintStyle: TextStyle(color:Colors.black26), // ให้ข้อความแนะนำเป็นสีดำจาง
                enabledBorder: InputBorder.none, // ไม่แสดงเส้นขอบตอนช่องกรอกอยู่ในสถานะปกติ
                focusedBorder: InputBorder.none, // ไม่แสดงเส้นขอบตอนผู้ใช้เลือกช่องกรอก
              ), // จบ InputDecoration
            ), // จบ TextField
            const Divider( // สร้างเส้นคั่นแนวนอน
              color: Colors.black26, // ให้เส้นคั่นเป็นสีดำจาง
              thickness: 1, // กำหนดความหนาของเส้นเป็น 1 หน่วย
            ), // จบ Divider
            starRow(rating), // เรียกฟังก์ชันแสดงดาวตามคะแนนของอาหารรายการนี้
          ], // จบรายการ Widget ภายใน Column
        ), // จบ Column
      ), // จบ Container
    ); // จบ Expanded และคืนการ์ดออกจากฟังก์ชัน
  } // จบฟังก์ชัน foodCard

  void updateAverage(int a, int b, int c) { // รับคะแนนสามรายการเพื่ออัปเดตผลลัพธ์; void หมายถึงไม่คืนค่า
    double avg = (a + b + c) / 3; // บวกคะแนนแล้วหารด้วย 3 เก็บเป็น double เพราะมีทศนิยมได้
    setState(() { // เปลี่ยนสถานะและแจ้ง Flutter ให้สร้างหน้าจอใหม่
      r1 = a; // อัปเดตคะแนนอาหารรายการแรก
      r2 = b; // อัปเดตคะแนนอาหารรายการที่สอง
      r3 = c; // อัปเดตคะแนนอาหารรายการที่สาม
      avgStar = avg.round(); // ปัดค่าเฉลี่ยเป็นจำนวนเต็มเพื่อใช้แสดงดาว
      msg = 'Average rating: ${avg.toStringAsFixed(2)}'; // สร้างข้อความค่าเฉลี่ย โดยแสดงทศนิยม 2 ตำแหน่ง
    }); // จบการเปลี่ยนสถานะ
  } // จบฟังก์ชัน updateAverage

  void randomRate() { // สร้างฟังก์ชันสำหรับปุ่มสุ่มคะแนน
    int a = Random().nextInt(5) + 1; // สุ่มเลข 0-4 แล้วบวก 1 ให้ได้คะแนนแรกระหว่าง 1-5
    int b = Random().nextInt(5) + 1; // สุ่มคะแนนที่สองระหว่าง 1-5
    int c = Random().nextInt(5) + 1; // สุ่มคะแนนที่สามระหว่าง 1-5
    c1.text = '$a'; // นำคะแนนแรกมาเป็นข้อความ แล้วใส่ในช่องกรอกแรก
    c2.text = '$b'; // ใส่คะแนนที่สองในช่องกรอกที่สอง
    c3.text = '$c'; // ใส่คะแนนที่สามในช่องกรอกที่สาม
    updateAverage(a, b, c); // ส่งคะแนนที่สุ่มได้ไปอัปเดตดาวและค่าเฉลี่ย
  } // จบฟังก์ชัน randomRate

  void rate() { // สร้างฟังก์ชันสำหรับตรวจและคำนวณคะแนนที่ผู้ใช้กรอก
    int? a = int.tryParse(c1.text.trim()); // อ่านช่องแรก ตัดช่องว่างหัวท้าย และแปลงเป็นจำนวนเต็ม; ถ้าแปลงไม่ได้จะเป็น null
    int? b = int.tryParse(c2.text.trim()); // อ่านและแปลงคะแนนช่องที่สอง
    int? c = int.tryParse(c3.text.trim()); // อ่านและแปลงคะแนนช่องที่สาม
    if (a == null || b == null || c == null) { // ถ้าช่องใดแปลงไม่ได้ ให้ทำส่วนนี้; || หมายถึง หรือ
      setState(() { // เปลี่ยนสถานะเพื่อให้หน้าจอแสดงข้อผิดพลาด
        r1 = 0; // ตั้งดาวของอาหารรายการแรกเป็น 0
        r2 = 0; // ตั้งดาวของอาหารรายการที่สองเป็น 0
        r3 = 0; // ตั้งดาวของอาหารรายการที่สามเป็น 0
        avgStar = 0; // ตั้งดาวเฉลี่ยเป็น 0
        msg = 'Error: invalid input'; // กำหนดข้อความว่าข้อมูลไม่ถูกต้อง
      }); // จบการเปลี่ยนสถานะ
      return; // จบฟังก์ชัน rate ทันที ไม่ไปทำส่วนที่เหลือ
    } // จบเงื่อนไขตรวจ null
    if (a < 1 || a > 5 || b < 1 || b > 5 || c < 1 || c > 5) { // ตรวจว่ามีคะแนนใดอยู่นอกช่วง 1-5 หรือไม่
      setState(() { // เปลี่ยนสถานะเมื่อคะแนนอยู่นอกช่วงที่กำหนด
        r1 = 0; // ตั้งดาวอาหารรายการแรกเป็น 0
        r2 = 0; // ตั้งดาวอาหารรายการที่สองเป็น 0
        r3 = 0; // ตั้งดาวอาหารรายการที่สามเป็น 0
        avgStar = 0; // ตั้งดาวเฉลี่ยเป็น 0
        msg = 'Error: invalid input'; // กำหนดข้อความข้อผิดพลาด
      }); // จบการเปลี่ยนสถานะ
      return; // จบฟังก์ชันทันที เพราะคะแนนไม่ถูกต้อง
    } // จบเงื่อนไขตรวจช่วงคะแนน
    updateAverage(a, b, c); // เมื่อทุกคะแนนถูกต้อง ส่งไปคำนวณและอัปเดตผลลัพธ์
  } // จบฟังก์ชัน rate

  void reset() { // สร้างฟังก์ชันสำหรับปุ่มล้างข้อมูล
    setState(() { // เปลี่ยนสถานะและให้หน้าจอแสดงข้อมูลหลังล้าง
      c1.clear(); // ล้างข้อความในช่องกรอกแรก
      c2.clear(); // ล้างข้อความในช่องกรอกที่สอง
      c3.clear(); // ล้างข้อความในช่องกรอกที่สาม
      r1 = 0; // ตั้งคะแนนอาหารรายการแรกเป็น 0
      r2 = 0; // ตั้งคะแนนอาหารรายการที่สองเป็น 0
      r3 = 0; // ตั้งคะแนนอาหารรายการที่สามเป็น 0
      avgStar = 0; // ตั้งดาวเฉลี่ยเป็น 0
      msg = ''; // ล้างข้อความผลลัพธ์หรือข้อผิดพลาด
    }); // จบการเปลี่ยนสถานะ
  } // จบฟังก์ชัน reset

  @override // ระบุว่าเขียนเมธอด dispose แทนของคลาสแม่
  void dispose() { // เมธอดที่ทำงานเมื่อ State นี้ถูกนำออกจากการใช้งาน
    c1.dispose(); // คืนทรัพยากรของตัวควบคุมช่องกรอกแรก
    c2.dispose(); // คืนทรัพยากรของตัวควบคุมช่องกรอกที่สอง
    c3.dispose(); // คืนทรัพยากรของตัวควบคุมช่องกรอกที่สาม
    super.dispose(); // เรียก dispose ของคลาสแม่เพื่อจัดการส่วนที่เหลือ
  } // จบเมธอด dispose

  @override // ระบุว่าเขียนเมธอด build แทนของคลาสแม่
  Widget build(BuildContext context) { // สร้างหน้าจอ โดย context เป็นข้อมูลตำแหน่งของ widget ในโครงสร้างหน้าจอ
    return MaterialApp( // คืนโครงแอปแบบ Material
      home: Scaffold( // กำหนดหน้าหลัก โดยใช้ Scaffold เป็นโครงหน้าจอ
        appBar: AppBar( // สร้างแถบด้านบนของหน้าจอ
          title: const Text('Quiz 1: Food Rating App'), // แสดงชื่อแอปบนแถบด้านบน
        ), // จบ AppBar
        body: SingleChildScrollView( // สร้างพื้นที่เนื้อหาที่เลื่อนในแนวตั้งได้
          child: Column( // จัดเนื้อหาหลักเรียงจากบนลงล่าง
            children: [ // เริ่มรายการ Widget ในหน้าจอ
              Padding( // สร้างพื้นที่เว้นระยะรอบแถวการ์ดอาหาร
                padding: const EdgeInsets.all(8.0), // เว้นระยะทุกด้าน 8 หน่วย
                child: Row( // จัดการ์ดอาหารเรียงในแนวนอน
                  children: [ // เริ่มรายการการ์ดและช่องว่างในแถว
                    foodCard(img1, c1, r1), // สร้างการ์ดสเต๊ก โดยส่งรูป ตัวควบคุมช่องแรก และคะแนนแรก
                    const SizedBox(width: 8), // เว้นระยะระหว่างการ์ดแรกกับการ์ดที่สอง 8 หน่วย
                    foodCard(img2, c2, r2), // สร้างการ์ดล็อบสเตอร์
                    const SizedBox(width: 8), // เว้นระยะระหว่างการ์ดที่สองกับการ์ดที่สาม 8 หน่วย
                    foodCard(img3, c3, r3), // สร้างการ์ดเค้ก
                  ], // จบรายการ Widget ในแถวการ์ด
                ), // จบ Row ของการ์ดอาหาร
              ), // จบ Padding รอบแถวการ์ด
              const SizedBox(height: 8), // เว้นระยะจากการ์ดลงมาถึงแถวปุ่ม 8 หน่วย
              Row( // สร้างแถวสำหรับวางปุ่ม
                mainAxisAlignment: MainAxisAlignment.center, // จัดกลุ่มปุ่มให้อยู่กึ่งกลาง
                children: [ // เริ่มรายการปุ่มและช่องว่าง
                  FilledButton.tonal( // สร้างปุ่มแบบ tonal สำหรับสุ่มคะแนน
                    onPressed: randomRate, // เมื่อกดปุ่ม ให้เรียกฟังก์ชัน randomRate
                    child: const Text('Random Rate'), // แสดงข้อความ Random Rate บนปุ่ม
                    style: FilledButton.styleFrom(foregroundColor: const Color.fromARGB(255, 10, 49, 148)), // กำหนดสีข้อความหรือไอคอนของปุ่มเป็นสีน้ำเงิน
                  ), // จบปุ่ม Random Rate
                  const SizedBox(width: 8), // เว้นระยะระหว่างปุ่ม 8 หน่วย
                  FilledButton.tonal( // สร้างปุ่มสำหรับตรวจและคำนวณคะแนน
                    onPressed: rate, // เมื่อกดปุ่ม ให้เรียกฟังก์ชัน rate
                    child: const Text('Rate'), // แสดงข้อความ Rate บนปุ่ม
                    style: FilledButton.styleFrom(foregroundColor: const Color.fromARGB(255, 10, 49, 148)), // กำหนดสีข้อความหรือไอคอนเป็นสีน้ำเงิน
                  ), // จบปุ่ม Rate
                  const SizedBox(width: 8), // เว้นระยะระหว่างปุ่ม 8 หน่วย
                  FilledButton.tonal( // สร้างปุ่มสำหรับล้างข้อมูล
                    onPressed: reset, // เมื่อกดปุ่ม ให้เรียกฟังก์ชัน reset
                    child: const Text('Reset'), // แสดงข้อความ Reset บนปุ่ม
                    style: FilledButton.styleFrom(foregroundColor: const Color.fromARGB(255, 10, 49, 148)), // กำหนดสีข้อความหรือไอคอนเป็นสีน้ำเงิน
                  ), // จบปุ่ม Reset

                ], // จบรายการ Widget ในแถวปุ่ม
              ), // จบ Row ของปุ่ม
              const SizedBox(height: 16), // เว้นระยะจากปุ่มลงมาถึงข้อความ 16 หน่วย
              if (msg.isNotEmpty) // เพิ่ม Text ด้านล่างเฉพาะเมื่อ msg มีข้อความ
                Text( // สร้าง Widget สำหรับแสดงข้อความ
                  msg, // ใช้ข้อความค่าเฉลี่ยหรือข้อผิดพลาดที่เก็บใน msg
                ), // จบ Text
              const SizedBox(height: 4), // เว้นระยะก่อนแถวดาวเฉลี่ย 4 หน่วย
              starRow(avgStar), // แสดงดาวเฉลี่ย โดยส่งจำนวนดาวจาก avgStar
              const SizedBox(height: 16), // เว้นพื้นที่ด้านล่างอีก 16 หน่วย
            ], // จบรายการ Widget ของเนื้อหาหลัก
          ), // จบ Column หลัก
        ), // จบ SingleChildScrollView
      ), // จบ Scaffold
    ); // จบ MaterialApp และคืนหน้าจอจาก build
  } // จบเมธอด build
} // จบคลาส _LabTestState