
class Filters {
	final String? dateFrom;
	final String? dateTo;
	final String? permission;
	final String? competitions;

	const Filters({
		this.dateFrom, 
		this.dateTo, 
		this.permission, 
		this.competitions, 
	});

	@override
	String toString() {
		return 'Filters(dateFrom: $dateFrom, dateTo: $dateTo, permission: $permission, competitions: $competitions)';
	}

	factory Filters.fromMap(Map<String, dynamic> data) => Filters(
				dateFrom: data['dateFrom'] as String?,
				dateTo: data['dateTo'] as String?,
				permission: data['permission'] as String?,
				competitions: data['competitions'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'dateFrom': dateFrom,
				'dateTo': dateTo,
				'permission': permission,
				'competitions': competitions,
			};

  
	Filters copyWith({
		String? dateFrom,
		String? dateTo,
		String? permission,
		String? competitions,
	}) {
		return Filters(
			dateFrom: dateFrom ?? this.dateFrom,
			dateTo: dateTo ?? this.dateTo,
			permission: permission ?? this.permission,
			competitions: competitions ?? this.competitions,
		);
	}
}
