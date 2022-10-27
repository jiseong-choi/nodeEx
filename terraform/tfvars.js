const fs = require("fs");
const fsExtra = require("fs-extra");
const { program } = require("commander");
const { flatten, unflatten } = require("flat");
const packageJson = require("../package.json");

program
  .option("-d --debug", "output extra debugging")
  .requiredOption("--path <path>", "path to tfvars file")
  .requiredOption("--output-path <outputPath>", "path to output tfvars file")
  .requiredOption("--service <service>", packageJson.name)
  .requiredOption("--ecr-repo <ecr-name>", "ecr repo name")
  .requiredOption("--root-domain <root-domain>", "root domain")
  .requiredOption("--record-domain <record-domain>", "record domain")
  .option("--port <port>", "port to expose", "8000")
  .option("--database-port <port>", "database port to expose", "3306")
  .option("--region <region>", "aws region to deploy", "ap-northeast-2")
  .option("--profile <profile>", "aws profile", "default")
  .option("--vpc-cidr <cidr>", "aws vpc cidr block", "10.0.0.0/16")
  .option("--instance-count <count>", "aws instance count", "2")
  .option(
    "--availability-zone <zones>",
    "aws availability zone",
    "ap-northeast-2a,ap-northeast-2b"
  )
  .option("--min-capacity <min-capacity>", "min capacity", "1")
  .option("--max-capacity <max-capacity>", "max capacity", "2")
  .option("--instance-cpu <instance-cpu>", "instance cpu size", "1024")
  .option("--instance-memory <instance-memory>", "instance memory size", "2048")
  .option("--container-cpu <container-cpu>", "container cpu size", "512")
  .option(
    "--container-memory <container-memory>",
    "container memory size",
    "1024"
  )
  .parse(process.argv);

// init

const updateOptionsNumberValue = (options, keys) => {
  keys.forEach((key) => {
    if (options[key]) {
      options[key] = Number(options[key]);
    }
  });

  return options;
};

const options = updateOptionsNumberValue(program.opts(), [
  "port",
  "databasePort",
  "instanceCount",
  "containerCpu",
  "containerMemory",
  "minCapacity",
  "maxCapacity",
]);

// debug
if (options.debug) console.log(options);

const getTFVars = (path) => {
  if (!fs.existsSync(path)) {
    return process.exit(1);
  }

  const file = fsExtra.readJsonSync(path);
  const flattenFile = flatten(file);

  for (const [key, value] of Object.entries(flattenFile)) {
    if (
      typeof value !== "string" ||
      !value.includes("<") ||
      !value.includes(">")
    )
      continue;

    if (value.includes("<SERVICE_NAME>")) {
      flattenFile[key] = value.replace("<SERVICE_NAME>", options.service);
    }
    if (value.includes("<ECR_REPO>")) {
      flattenFile[key] = options.ecrRepo;
    }
    if (value.includes("<PORT>")) {
      flattenFile[key] = options.port;
    }
    if (value.includes("<DATABASE_PORT>")) {
      flattenFile[key] = options.databasePort;
    }
    if (value.includes("<REGION>")) {
      flattenFile[key] = value.replace("<REGION>", options.region);
    }
    if (value.includes("<AVAILABILITY_ZONE>")) {
      flattenFile[key] = options.availabilityZone.split(",");
    }
    if (value.includes("<PROFILE>")) {
      flattenFile[key] = options.profile;
    }
    if (value.includes("<VPC_CIDR>")) {
      flattenFile[key] = options.vpcCidr;
    }
    if (value.includes("<ROOT_DOMAIN>")) {
      flattenFile[key] = value.replace("<ROOT_DOMAIN>", options.rootDomain);
    }
    if (value.includes("<RECORD_DOMAIN>")) {
      flattenFile[key] = value.replace("<RECORD_DOMAIN>", options.recordDomain);
    }
    if (value.includes("<MIN_CAPACITY>")) {
      flattenFile[key] = options.minCapacity;
    }
    if (value.includes("<MAX_CAPACITY>")) {
      flattenFile[key] = options.maxCapacity;
    }
    if (value.includes("<INSTANCE_COUNT>")) {
      flattenFile[key] = options.instanceCount;
    }
    if (value.includes("<INSTANCE_CPU>")) {
      flattenFile[key] = options.instanceCpu;
    }
    if (value.includes("<INSTANCE_MEMORY>")) {
      flattenFile[key] = options.instanceMemory;
    }
    if (value.includes("<CONTAINER_CPU>")) {
      flattenFile[key] = options.containerCpu;
    }
    if (value.includes("<CONTAINER_MEMORY>")) {
      flattenFile[key] = options.containerMemory;
    }

    const newConfig = unflatten(flattenFile);
    fsExtra.writeJsonSync(`./${options.outputPath}`, newConfig, { spaces: 2 });
  }
};

getTFVars(options.path);
