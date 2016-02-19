import argparse
import glob
import os

import numpy as np
import pandas as ps

from fadapa import Fadapa

fastqc_output_dir_name = 'stdin_fastqc'
fastqc_output_file_name = 'fastqc_data.txt'

fastqc_basic_stats_name = 'Basic Statistics'
fastqc_dup_levels_name = 'Sequence Duplication Levels'
fastqc_per_base_qual_name = 'Per base sequence quality'
fastqc_per_seq_qual_name = 'Per sequence quality scores'

fastqc_basic_stats_keys = [
    ('Sequences flagged as poor quality', 'num_seqs_flagged_poor_qual'),
    ('Sequence length', 'seq_length'),
    ('%GC', 'percent_gc')
]

fastqc_dup_levels_keys = [
    ('Total Deduplicated Percentage', 'total_dup_percent')
]

fastqc_dup_levels = [
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '>10', '>50',
    '>100', '>500', '>1k', '>5k', '>10k+'
]

dup_level_name_prefixes = ['dup_level_dedup_', 'dup_level_total_']

per_base_qual_median_name = 'per_base_qual_median'
per_base_qual_mean_name = 'per_base_qual_mean'
per_base_qual_mean_min_name = 'per_base_qual_mean_min'
per_base_qual_mean_max_name = 'per_base_qual_mean_max'

per_seq_qual_bucket_min = 0
per_seq_qual_bucket_max = 60
per_seq_qual_bucket_size = 5
per_seq_qual_bucket_prefix = 'per_seq_qual_prop_seqs_'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('fastqc_output_dir', type=str, help='fastqc output dir')
    parser.add_argument('output_tsv', type=str, help='output TSV path')
    args = parser.parse_args()

    fastqc_runs = glob.glob(args.fastqc_output_dir + '/*')
    fastqc_run_names = map(os.path.basename, fastqc_runs)

    fastqc_rel_filepath = os.path.join(fastqc_output_dir_name, fastqc_output_file_name)
    fastqc_output_files = map(lambda r: os.path.join(r, fastqc_rel_filepath), fastqc_runs)

    rows = {}
    for fastqc_output_file, fastqc_run_name in zip(fastqc_output_files, fastqc_run_names):
        stats = get_stats_from_fastqc_file(fastqc_output_file)
        rows[fastqc_run_name] = stats

    cols = sorted(rows.values()[0].keys())
    table = {k: [] for k in rows.keys()}
    for c in cols:
        for k in rows.keys():
            table[k].append(rows[k][c])

    df = ps.DataFrame.from_dict(table, orient='index')
    df.to_csv(args.output_tsv, sep='\t')


def fadapa_from_filepath(filepath):
    return Fadapa(filepath)


def stats_from_fadapa(f, stats_name):
    stats = f.clean_data(stats_name)
    stats_dict = {l[0]: l[1:] for l in stats}
    return stats_dict


def build_seq_qual_histogram(per_seq_quals):
    if 'Quality' in per_seq_quals.keys():
        del per_seq_quals['Quality']
    per_seq_quals = {int(k): float(v[0]) for k, v in per_seq_quals.items()}
    total_seqs = sum(per_seq_quals.values())
    prop_per_seq_quals = {k: v / total_seqs for k, v in per_seq_quals.items()}
    min_qual = per_seq_qual_bucket_min
    max_qual = per_seq_qual_bucket_max
    c_qual = min_qual
    hist = {}
    while c_qual <= max_qual:
        prop = 0.
        for i in xrange(per_seq_qual_bucket_size):
            k = c_qual + i
            if k in prop_per_seq_quals:
                prop += prop_per_seq_quals[k]
        bucket_key = '{}q{}_q{}'.format(per_seq_qual_bucket_prefix,
                                        c_qual, c_qual + per_seq_qual_bucket_size)
        hist[bucket_key] = prop
        c_qual += per_seq_qual_bucket_size
    return hist


def get_stats_from_fastqc_file(filepath):
    stats = {}
    f = fadapa_from_filepath(filepath)
    basic_stats = stats_from_fadapa(f, fastqc_basic_stats_name)
    dup_levels = stats_from_fadapa(f, fastqc_dup_levels_name)
    per_base_qual = stats_from_fadapa(f, fastqc_per_base_qual_name)
    per_seq_qual = stats_from_fadapa(f, fastqc_per_seq_qual_name)

    for fq_key, out_key in fastqc_basic_stats_keys:
        stats[out_key] = basic_stats[fq_key]

    for fq_key, out_key in fastqc_dup_levels_keys:
        stats[out_key] = dup_levels[fq_key]

    for d_level in fastqc_dup_levels:
        dups = dup_levels[d_level]
        for i, pref in enumerate(dup_level_name_prefixes):
            dup_stat = dups[i]
            out_key = '{}{}'.format(pref, d_level)
            stats[out_key] = dup_stat

    del per_base_qual['Base']
    base_quals_means = map(lambda l: float(l[0]), per_base_qual.values())
    base_quals_medians = map(lambda l: float(l[1]), per_base_qual.values())
    stats[per_base_qual_median_name] = np.median(base_quals_medians)
    stats[per_base_qual_mean_name] = np.average(base_quals_means)
    stats[per_base_qual_mean_min_name] = min(base_quals_means)
    stats[per_base_qual_mean_max_name] = max(base_quals_means)

    seq_qual_hist = build_seq_qual_histogram(per_seq_qual)
    stats.update(seq_qual_hist)

    return stats

if __name__ == '__main__':
    main()
