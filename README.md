# connect-image

Strimzi `KafkaConnect`용 이미지. `kind-dev-cluster`의 MQTT → Kafka 수집에 쓴다
(위키 intent 0007, 매니페스트는 `stream-platform`).

| 구성 | 버전 | 출처 |
| --- | --- | --- |
| 베이스 | `quay.io/strimzi/kafka:1.3.0-kafka-4.3.1` | Strimzi 1.3.0 + Kafka 4.3.1 |
| Stream Reactor MQTT source | 12.1.2 | GitHub Release zip (Apache-2.0), sha256 검증 |
| Confluent Avro 컨버터 | 8.3.2 | Confluent Hub zip (Confluent Community License 표기 포함), sha256 검증 |

- 태그: `kafka-<Kafka 버전>-<커밋 sha 7자>`. `latest`는 올리지 않는다
- 플랫폼: `linux/amd64`만 빌드한다 (집 서버 x86_64)
- 이 레포와 이미지는 public이다. 비밀값·MQTT 주소를 넣지 않는다
- 이미지는 GitHub Actions(`.github/workflows/build.yaml`)로만 올린다. 로컬에서 수동으로 올리지 않는다

## 로컬 확인

```bash
docker build --platform linux/amd64 -t connect-image:test .
docker run --rm --entrypoint ls connect-image:test -R /opt/kafka/plugins
```

## 버전 올리기

`Dockerfile`의 `ARG` 버전과 `*_SHA256`을 같이 바꾼다. sha256은 내려받은 zip에서 직접 계산한다.

## 라이선스 고지

- Stream Reactor MQTT 커넥터: Apache-2.0 (`kafka-connect-mqtt-12.1.2/LICENSE`)
- Confluent Avro 컨버터: Confluent Community License 1.0 (zip 안 `doc/LICENSE-ConfluentCommunity`).
  zip의 `manifest.json`은 Apache 2.0으로 적혀 있지만 `doc/LICENSE`는 "Confluent Community License, 단 client-*·avro-*
  라이브러리는 Apache 2.0"이라 더 엄격한 쪽을 따른다. 재배포는 허용되고(1.1 (c)), 조건은 저작권 고지를 지우지 않고
  아래 문구를 각 사본에 함께 두는 것이다. 이미지는 zip을 풀어 그대로 담으므로 라이선스 파일이 같이 들어간다.
  금지된 용도(Confluent와 경쟁하는 온라인 서비스 제공)가 아니다

> This software is made available by Confluent, Inc., under the terms of the Confluent Community License Agreement,
> Version 1.0 located at http://www.confluent.io/confluent-community-license. BY INSTALLING, DOWNLOADING, ACCESSING,
> USING OR DISTRIBUTING ANY OF THE SOFTWARE, YOU AGREE TO THE TERMS OF SUCH LICENSE AGREEMENT.
