# project-ack-aws-s3

An example Upbound control plane project for Amazon Web Services (AWS) using AWS Controllers for Kubernetes (ACK).

## Overview

A control plane project is a source-level representation of a Crossplane control
plane. It lets you treat your control plane configuration as a software project.
With a control plane project you can build your compositions using a language
like KCL or Python. This enables Crossplane schema-aware syntax highlighting,
autocompletion, and linting.

Read the [control plane project documentation][proj-docs] to learn more about
control plane projects.

This project defines a new `StorageBucket` API, which is powered by AWS S3 using the ACK S3 Controller.

## AWS Controllers for Kubernetes (ACK)

This project uses [AWS Controllers for Kubernetes (ACK)][ack-overview] to manage AWS resources. ACK lets you define and use AWS service resources directly from Kubernetes.

### S3 Controller

The project specifically uses the [ACK S3 Controller][ack-s3] to manage S3 buckets and related resources. This controller provides Kubernetes custom resources for:
- Buckets

### Installation via Upbound Addon

The ACK controllers are installed using the [Upbound ACK addon][addon-ack], which simplifies the deployment of ACK controllers in your control plane. This addon uses the official [ACK Helm charts][ack-chart] to install and configure the controllers.

## Project Structure

- `/apis`: Contains CompositeResourceDefinitions (XRDs) for this project
- `/examples`: Contains example resources for this project
- `/functions`: Contains embedded functions for this project
- `/tests`: Contains the related tests for this project

[proj-docs]: https://docs.upbound.io/core-concepts/projects/
[ack-overview]: https://aws-controllers-k8s.github.io/community/docs/community/overview/
[ack-s3]: https://github.com/aws-controllers-k8s/s3-controller
[addon-ack]: https://github.com/haarchri/addon-ack
[ack-chart]: https://github.com/aws-controllers-k8s/ack-chart/
