import 'package:characterbook/features/races/data/race_record.dart';
import 'package:characterbook/features/races/domain/race_model.dart';

class RaceMapper {
  const RaceMapper();

  Race toDomain(RaceRecord record) => Race(
        id: record.id,
        name: record.name,
        description: record.description,
        biology: record.biology,
        backstory: record.backstory,
        logo: record.logo,
        folderId: record.folderId,
        tags: record.tags,
        additionalImages: record.additionalImages,
        lastEdited: record.lastEdited,
      );

  RaceRecord toRecord(Race race) => RaceRecord(
        id: race.id,
        name: race.name,
        description: race.description,
        biology: race.biology,
        backstory: race.backstory,
        logo: race.logo,
        folderId: race.folderId,
        tags: race.tags,
        additionalImages: race.additionalImages,
        lastEdited: race.lastEdited,
      );
}
