import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/waiting_widget.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';
import '../model/faq_model.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final Set<int> _expandedIndices = {};

  @override
  void initState() {
    super.initState();
    getFaqRxObj.fetchFaq();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.cFFFFFF,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: UIHelper.kDefaulutPadding()),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            icon: Assets.icons.arrowBackBlack.image(
              width: 24.r,
              height: 24.r,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Questions fréquentes",
          style: TextFontStyle.textStyle24c000000InterTight700
              .copyWith(fontSize: 22.sp),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.allPrimaryColor,
        backgroundColor: AppColors.cFFFFFF,
        onRefresh: () async {
          await getFaqRxObj.fetchFaq();
        },
        child: StreamBuilder<FaqModel>(
          stream: getFaqRxObj.faqData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const Center(child: WaitingWidget());
            }

            if (snapshot.hasError) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    horizontal: UIHelper.kDefaulutPadding(), vertical: 40.h),
                child: Center(
                  child: Text(
                    "Une erreur s'est produite lors du chargement des questions.",
                    style: TextFontStyle.textStyle16c191919InterTight600,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final faqs = snapshot.data?.data ?? [];

            if (faqs.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    horizontal: UIHelper.kDefaulutPadding(), vertical: 40.h),
                child: Center(
                  child: Text(
                    "Aucune question trouvée pour le moment.",
                    style: TextFontStyle.textStyle16c191919InterTight600,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: UIHelper.kDefaulutPadding(), vertical: 12.h),
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                final faq = faqs[index];
                final isExpanded = _expandedIndices.contains(index);

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cFFFFFF,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.cF2F2F2),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        onExpansionChanged: (expanded) {
                          setState(() {
                            if (expanded) {
                              _expandedIndices.add(index);
                            } else {
                              _expandedIndices.remove(index);
                            }
                          });
                        },
                        trailing: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppColors.c191919,
                          size: 24.sp,
                        ),
                        title: Text(
                          faq.question ?? "",
                          style: TextFontStyle.textStyle15c222222InterTight500
                              .copyWith(fontSize: 14.sp),
                        ),
                        childrenPadding: EdgeInsets.only(
                            left: 16.w, right: 16.w, bottom: 16.h),
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              faq.answer ?? "",
                              style: TextFontStyle.textStyle14c8A8A8AInter400
                                  .copyWith(
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
