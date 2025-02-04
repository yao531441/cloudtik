# Run IntelAI Models benchmark on Cloudtik cluster

## 1. Create a new Cloudtik cluster with IntelAI Models
To prepare data and run Models on Cloudtik cluster, some tools must be installed in advance.
You have several options to do this.

### Option 1: Use a CloudTik oneAPI ML runtime and bootstrap IntelAI Models (Recommended)
In your cluster config under docker key, configure the oneAPI ML runtime image
and in bootstrap_commands, configure the command for preparing IntelAI Models.

```buildoutcfg
docker:
    image: "cloudtik/spark-ml-oneapi:nightly"

bootstrap_commands:
    - wget -O ~/bootstrap-models.sh https://raw.githubusercontent.com/oap-project/cloudtik/main/tools/benchmarks/ml/intelai-models/scripts/bootstrap-models.sh &&
        bash ~/bootstrap-models.sh
```

### Option 2: Use a CloudTik Spark ML runtime and bootstrap IntelAI Models
In your cluster config under docker key, configure the Spark ML runtime image
and in bootstrap_commands, configure the command for installing Intel Extension for PyTorch
and the command for preparing for IntelAI Models.

```buildoutcfg
```buildoutcfg
docker:
    image: "cloudtik/spark-ml-runtime:nightly"

bootstrap_commands:
    - wget -O ~/bootstrap-ipex.sh https://raw.githubusercontent.com/oap-project/cloudtik/main/tools/benchmarks/ml/intelai-models/scripts/bootstrap-ipex.sh &&
        bash ~/bootstrap-ipex.sh
    - wget -O ~/bootstrap-models.sh https://raw.githubusercontent.com/oap-project/cloudtik/main/tools/benchmarks/ml/intelai-models/scripts/bootstrap-models.sh &&
        bash ~/bootstrap-models.sh
```

### Option 3: Use exec commands to install on all nodes
If you cluster already started, you can run the installing command on all nodes to achieve the same.

Run the following command for installing for Intel Extension for PyTorch.
If you are using oneAPI ML runtime, you can skip this step.
```buildoutcfg
cloudtik exec your-cluster-config.yaml "wget -O ~/bootstrap-ipex.sh https://raw.githubusercontent.com/oap-project/cloudtik/main/tools/benchmarks/ml/intelai-models/scripts/bootstrap-ipex.sh && bash ~/bootstrap-ipex.sh" --all-nodes
```

Run the following command for preparing for IntelAI Models.
```buildoutcfg
cloudtik exec your-cluster-config.yaml "wget -O ~/bootstrap-models.sh https://raw.githubusercontent.com/oap-project/cloudtik/main/tools/benchmarks/ml/intelai-models/scripts/bootstrap-models.sh && bash ~/bootstrap-models.sh" --all-nodes
```

Please note that the toolkit installing may take a long time.
You may need to run the command with --tmux option for background execution
for avoiding terminal disconnection in the middle. And you don't know its completion.

## 2. Prepare data and run Models benchmark for a specific workload
We support the following specific Models cases:
- BERT-large [model name: bert-large](./use-cases/bert-large)
- DLRM [model name: dlrm](./use-cases/dlrm)
- Mask R-CNN [model name: maskrcnn](./use-cases/maskrcnn)
- ResNet-50 [model name: resnet50](./use-cases/resnet50)
- ResNeXt101 [model name: resnext-32x16d](./use-cases/resnext-32x16d)
- RNN-T [model name: rnnt](./use-cases/rnnt)
- SSD-ResNet-34 [model name: ssd-resnet34](./use-cases/ssd-resnet34)

### Preparing data
Run the following command for preparing data.
```buildoutcfg
cloudtik exec your-cluster-config.yaml 'bash $HOME/runtime/benchmark-tools/intelai_models/cloudtik/use-cases/model-name/scripts/prepare-data.sh'
```
Replace model-name to one of the model name above.

### Run inference
Run the following command for inference if supported.
```buildoutcfg
cloudtik exec your-cluster-config.yaml 'bash $HOME/runtime/benchmark-tools/intelai_models/cloudtik/use-cases/model-name/scripts/run_inference.sh'
```
Replace model-name to one of the model name above.

### Run training
Run the following command for training if supported.
```buildoutcfg
cloudtik exec your-cluster-config.yaml 'bash $HOME/runtime/benchmark-tools/intelai_models/cloudtik/use-cases/model-name/scripts/run_training.sh'
```
Replace model-name to one of the model name above.
