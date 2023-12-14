import fs from "node:fs";
import path from "node:path";

const pathToVODs = "/Volumes/inland/Videos/OBS";

const files = fs.readdirSync(pathToVODs);

const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
const gigabyteThreshold = 2;
const thirtyDaysAgo = new Date(Date.now() - 3 * oneDay);

const shouldDelete = process.argv.includes("--delete");
let numMatchingFiles = 0;
let totalSpaceToClear = 0;

files.forEach((file) => {
  const filePath = path.join(pathToVODs, file);
  const stats = fs.statSync(filePath);

  const fileSizeInGB = stats.size / 1e9; // convert from bytes to GB
  const fileModifiedDate = new Date(stats.mtime);

  if (fileSizeInGB > gigabyteThreshold && fileModifiedDate < thirtyDaysAgo) {
    numMatchingFiles++;
    totalSpaceToClear += fileSizeInGB;
    const fileAndSize = `${file} (${fileSizeInGB.toFixed(2)} GB)`;
    if (shouldDelete) {
      fs.unlinkSync(filePath);
      console.log(`Deleted file ${fileAndSize}`);
    } else {
      console.log(`Would have deleted file ${fileAndSize}`);
    }
  }
});

console.log(
  `Found ${numMatchingFiles} files (totaling ${totalSpaceToClear.toFixed(
    2
  )} GB)`
);

if (!shouldDelete && numMatchingFiles > 0) {
  console.log("\nTo actually delete the files, specify the --delete flag");
}
