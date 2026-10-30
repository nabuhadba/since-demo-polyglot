<?php

return [
    'openai' => [
        'key' => $_ENV['OPENAI_API_KEY'] ?? '',
        'model' => $_ENV['OPENAI_MODEL'] ?? 'gpt-5.6-terra',
        'base_uri' => 'https://api.openai.com/v1/',
    ],
    'jwt' => [
        'secret' => $_ENV['JWT_SECRET'] ?? '',
    ],
];
