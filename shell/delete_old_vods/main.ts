import fs from "node:fs";
import path from "node:path";

const pathToVODs = "/Volumes/inland/Videos/OBS";

const files = fs.readdirSync(pathToVODs);

const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
const gigabyteThreshold = 2;
const thirtyDaysAgo = new Date(Date.now() - 30 * oneDay);

files.forEach((file) => {
  const filePath = path.join(pathToVODs, file);
  const stats = fs.statSync(filePath);

  const fileSizeInGB = stats.size / 1e9; // convert from bytes to GB
  const fileModifiedDate = new Date(stats.mtime);

  if (fileSizeInGB > gigabyteThreshold && fileModifiedDate < thirtyDaysAgo) {
    fs.unlinkSync(filePath);
    console.log(`Deleted file ${filePath}`);
  }
});
