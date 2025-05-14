document.addEventListener('DOMContentLoaded', function () {
    // 활동 차트
    const activityCtx = document.getElementById('activityChart').getContext('2d');

    // 최근 30일 날짜 생성
    const dates = [];
    const now = new Date();
    for (let i = 29; i >= 0; i--) {
        const date = new Date(now);
        date.setDate(date.getDate() - i);
        const formattedDate = `${date.getMonth() + 1}/${date.getDate()}`;
        dates.push(formattedDate);
    }

    // 샘플 데이터
    const postData = Array.from({length: 30}, () => Math.floor(Math.random() * 10) + 1);
    const productData = Array.from({length: 30}, () => Math.floor(Math.random() * 8) + 1);
    const memberData = Array.from({length: 30}, () => Math.floor(Math.random() * 5) + 1);

    const activityChart = new Chart(activityCtx, {
        type: 'line',
        data: {
            labels: dates,
            datasets: [
                {
                    label: '게시글',
                    data: postData,
                    borderColor: '#0dcaf0',
                    backgroundColor: 'rgba(13, 202, 240, 0.1)',
                    tension: 0.4,
                    fill: true
                },
                {
                    label: '상품',
                    data: productData,
                    borderColor: '#198754',
                    backgroundColor: 'rgba(25, 135, 84, 0.1)',
                    tension: 0.4,
                    fill: true
                },
                {
                    label: '회원가입',
                    data: memberData,
                    borderColor: '#0d6efd',
                    backgroundColor: 'rgba(13, 110, 253, 0.1)',
                    tension: 0.4,
                    fill: true
                }
            ]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'top',
                },
                tooltip: {
                    mode: 'index',
                    intersect: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0
                    }
                }
            },
            interaction: {
                mode: 'nearest',
                axis: 'x',
                intersect: false
            }
        }
    });
});
