<?php

return [
    'openai' => [
        'key' => $_ENV['OPENAI_API_KEY'] ?? '',
        'model' => $_ENV['OPENAI_MODEL'] ?? 'gpt-3.5-turbo',
        'base_uri' => 'https://api.openai.com/v1/',
    ],
    'jwt' => [
        'secret' => $_ENV['JWT_SECRET'] ?? '',
    ],
];
