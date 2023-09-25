import { dataSource } from "../../services/database";
import { UserSettingsEntity } from "./userSettingsEntity";

const userSettingsRepository = dataSource.getRepository(UserSettingsEntity);

export const findSettings = async (userId: string): Promise<Record<string, string>> => {
  const settings = await userSettingsRepository.findBy({ userId });
  return settings.reduce((acc, setting) => ({ ...acc, [setting.settingKey]: setting.settingValue }), {});
}

export const findSettingsValue = async (userId: string, settingKey: string): Promise<string | null> => {
  const setting = await userSettingsRepository.findOneBy({ userId, settingKey });
  return setting?.settingValue ?? null;
};

export const upsertSettingsValue = async (userUid: string, settings: Record<string, string>): Promise<void> => {
  await dataSource.transaction(async (transactionalEntityManager) => {
    const userSettingsRepository = transactionalEntityManager.getRepository(UserSettingsEntity);

    const existingSettings = await userSettingsRepository.findBy({ userId: userUid });
    const newSettings = Object.entries(settings).map(([settingKey, settingValue]) => {
      const existingSetting = existingSettings.find((s) => s.settingKey === settingKey);
      return existingSetting
        ? userSettingsRepository.merge(existingSetting, { settingValue })
        : userSettingsRepository.create({ userId: userUid, settingKey, settingValue });
    });

    await userSettingsRepository.save(newSettings);
  });
};
