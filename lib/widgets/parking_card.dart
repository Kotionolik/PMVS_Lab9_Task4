import 'package:flutter/material.dart';
import '../models/parking_lot.dart';
import '../core/extensions/context_extensions.dart';
class ParkingCard extends StatefulWidget {
  final ParkingLot lot;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  const ParkingCard({super.key, required this.lot,
    required this.onTap, required this.onFavorite});
  @override
  State<ParkingCard> createState() => _ParkingCardState();
}
class _ParkingCardState extends State<ParkingCard> {
  bool _hover = false;
  void _menu(Offset p) async {
    final v = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(p.dx, p.dy, p.dx, p.dy),
      items: [
        PopupMenuItem(value: 'fav', child:
          Text(context.l10n.addToFavorites)),
        PopupMenuItem(value: 'open', child:
          Text(context.l10n.bookNow)),
      ],
    );
    if (v == 'fav') widget.onFavorite();
    if (v == 'open') widget.onTap();
  }
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
      onSecondaryTapDown: (d) => _menu(d.globalPosition),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _hover ? (Matrix4.identity()..scale(1.03)) :
          Matrix4.identity(),
        child: Card(
          elevation: _hover ? 8 : 2,
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.local_parking, color: Colors.blue),
                  const SizedBox(width: 6),
                  Expanded(child: Text(widget.lot.name,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
                  IconButton(
                    icon: Icon(widget.lot.isFavorite ?
                      Icons.favorite : Icons.favorite_border),
                    onPressed: widget.onFavorite,
                  ),
                ]),
                Text('${l10n.freeSpots}: ${widget.lot.freeSpots}/${widget.lot.totalSpots}'),
                Text('${l10n.pricePerHour}: \$${widget.lot.pricePerHour.toStringAsFixed(2)}'),
              ]),
            ),
          ),
        ),
      ),
      ),
    );
  }
}