import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class SuggestCard extends StatelessWidget {
  final String groupName;
  final String? description;
  final String? imageUrl;
  final VoidCallback? onJoinGroup;
  final VoidCallback? onRemoveSuggestion;
  final VoidCallback? onTap;
  final bool isRow; 

  const SuggestCard({
    super.key,
    required this.groupName,
    this.description,
    this.imageUrl,
    this.onJoinGroup,
    this.onRemoveSuggestion,
    this.onTap,
    this.isRow = true, 
  });

  @override
  Widget build(BuildContext context) {
    double cardWidth = (MediaQuery.of(context).size.width * (2 / 3)).clamp(250, 300);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
      child: Container(
        width: isRow ? cardWidth : null, 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: InkWell(
              onTap: onTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    imageUrl ?? 'https://picsum.photos/500',
                    height: isRow ? 160 : 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          groupName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.textStyle17,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.textStyle14,
                        ),
                        const SizedBox(height: 16),
                        
                        if (isRow) 
                          buildRowButtons() 
                        else 
                          buildColumnButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRowButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomSquareButton(
            label: "Join",
            onTap: onJoinGroup ?? () {},
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomSquareButton(
            label: "Remove",
            onTap: onRemoveSuggestion ?? () {},
            backgroundColor: Colors.grey[200],
            textColor: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildColumnButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomSquareButton(
          label: "Join",
          onTap: onJoinGroup ?? () {},
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          height: 10, 
        ),
        const SizedBox(height: 8),
        CustomSquareButton(
          label: "Remove",
          onTap: onRemoveSuggestion ?? () {},
          backgroundColor: Colors.grey[200],
          textColor: Colors.black,
          height: 10,
        ),
      ],
    );
  }
}