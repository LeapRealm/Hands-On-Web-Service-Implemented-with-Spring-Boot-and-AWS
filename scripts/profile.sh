#!/usr/bin/env bash

# 쉬고 있는 profile 찾기 : real1 이 사용 중이면 real2 가 쉬고 있고, 반대면 real1 이 쉬고 있음
function findIdleProfile() {
    RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/profile)

    if [ "${RESPONSE_CODE}" -ge 400 ]; then  # 400 보다 크면(즉, 40x/50x 에러 모두 포함)
        CURRENT_PROFILE=real2
    else
        CURRENT_PROFILE=$(curl -s http://localhost/profile)
    fi

    if [ "${CURRENT_PROFILE}" == real1 ]; then
        IDLE_PROFILE=real2
    else
        IDLE_PROFILE=real1
    fi

    echo "${IDLE_PROFILE}"
}

# 쉬고 있는 profile 의 port 찾기
function findIdlePort() {
    IDLE_PROFILE=$(findIdleProfile)

    if [ "${IDLE_PROFILE}" == real1 ]; then
        echo "8081"
    else
        echo "8082"
    fi
}