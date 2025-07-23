import 'package:flutter/material.dart';

class PolicyOfServiceWidget extends StatelessWidget {
  const PolicyOfServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // قسم المقدمة
            _buildSectionTitle('1. مقدمة'),
            _buildSectionContent(
              'مرحباً بك في تطبيقنا! هذه الشروط والاحكام تحدد القواعد واللوائح لاستخدام موقعنا الإلكتروني وتطبيقنا. الوصول إلى هذا التطبيق يعني أنك تقبل هذه الشروط والأحكام. لا تواصل استخدام التطبيق إذا كنت لا توافق على جميع الشروط والأحكام المذكورة في هذه الصفحة.',
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('2. استخدام الخدمة'),
            _buildSectionContent(
              'أنت توافق على استخدام خدماتنا فقط للاغراض المشروعة ووفقًا لهذه الشروط. تتعهد بعدم استخدام الخدمة:\n'
              '- بأي طريقة تنتهك أي قانون أو لائحة معمول بها.\n'
              '- لغرض استغلال أو إيذاء أو محاولة استغلال أو إيذاء القاصرين بأي شكل من الأشكال.\n'
              '- لإرسال أي مواد إعلانية أو ترويجية غير مرغوب فيها "بريد عشوائي".',
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('3. الملكية الفكرية'),
            _buildSectionContent(
              'الخدمة ومحتواها الأصلي والميزات والوظائف هي وستبقى ملكية حصرية للشركة ومرخصيها. الخدمة محمية بموجب حقوق النشر والعلامات التجارية والقوانين الأخرى في كل من البلدان الأجنبية والمحلية.',
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('4. إنهاء الخدمة'),
            _buildSectionContent(
              'يجوز لنا إنهاء أو تعليق حسابك على الفور، دون إشعار مسبق أو مسؤولية، لأي سبب من الأسباب، بما في ذلك على سبيل المثال لا الحصر إذا انتهكت الشروط.',
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('5. إخلاء المسؤولية'),
            _buildSectionContent(
              'استخدامك للخدمة على مسؤوليتك وحدك. يتم توفير الخدمة على أساس "كما هي" و "كما هي متاحة". يتم توفير الخدمة دون ضمانات من أي نوع، سواء كانت صريحة أو ضمنية.',
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('للتواصل معنا'),
            _buildSectionContent(
              'إذا كان لديك أي أسئلة حول هذه الشروط، يرجى الاتصال بنا على البريد الإلكتروني: contact@example.com',
            ),
            const SizedBox(height: 40),

            Center(
              child: Text(
                'ملاحظة: هذا النص هو مثال توضيحي فقط ولا يعتبر وثيقة قانونية. يجب استشارة محامٍ لصياغة شروط خدمة خاصة بتطبيقك.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 8.0),
      child: Text(
        content,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }
}
